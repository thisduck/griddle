module Griddle
  module HasGridAttachment
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end

    included do
      class_attribute :attachment_definitions
    end
    
    module ClassMethods
      def has_grid_attachment name, options = {}
        self.attachment_definitions = {} if attachment_definitions.nil?
        attachment_definitions[name] = options

        after_save :save_attached_files if respond_to? :after_save
        after_destroy :destroy_attached_files if respond_to? :after_destroy
        
        define_method(name) do |*args|
          attachment_for(name, options)
        end
        
        define_method("#{name}=") do |file|
          attachment_for(name, options).assign(file)
        end        
      end
    end
    
    module InstanceMethods
      
      def attachment_for name, options = {}
        @_gripster_attachments ||= {}
        @_gripster_attachments[name] ||= Attachment.for(name, self, options)
      end
      
      def destroy_attached_files
        each_attachment{|name, attachment| attachment.destroy }
      end
      
      def each_attachment
        self.class.attachment_definitions.each do |name, definition|
          yield(name, attachment_for(name))
        end
      end
      
      def save_attached_files
        each_attachment do |name, attachment|
          attachment.owner_id = self.id
          attachment.send(:save) unless attachment.nil?
        end
      end
    end
  end
end

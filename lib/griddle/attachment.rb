module Griddle
  class Attachment

    def self.attachment_for(name, owner_type, owner_id)
      options = {:name => name, :owner_type => owner_type, :owner_id => owner_id}
      record = collection.find_one(options)
      return new(record) unless record.nil?
      return new(options)
    end

    def self.collection
      @collection ||= Griddle.database.collection('griddle.attachments')
    end
    
    def self.for(name, owner, options = {})
      a = attachment_for(name, owner.class.to_s, owner.id)
      a.styles = options.dup.delete(:styles) || {}
      a
    end

    def self.valid_attributes
      [:name, :owner_id, :owner_type, :file_name, :file_size, :content_type, :styles, :options]
    end
    #     belongs_to :owner, :polymorphic => true
    
    attr_accessor :attributes

    def initialize(attributes = {})
      @attributes = attributes.symbolize_keys
    end
    
    def assign(uploaded_file)
      if valid_assignment?(uploaded_file)
        self.file = uploaded_file
      end
    end
    
    def attributes
      @attributes
    end

    def attributes=(attributes)
      @attributes.merge!(attributes).symbolize_keys
    end

    def collection
      @collection ||= self.class.collection
    end
    
    def destroy
      destroy_file
      collection.remove({:name => name, :owner_type => owner_type, :owner_id => owner_id})
    end
    
    def method_missing(method, *args, &block)
      key = method.to_s.gsub(/\=$/, '').to_sym
      if self.class.valid_attributes.include?(key)
        if key != method
          @attributes[key] = args[0]
        else
          @attributes[key]
        end
      else
        super
      end
    end
    
    def destroy_file
      GridFS::GridStore.unlink(Griddle.database, grid_key)
    end
    
    def exists?
      !file_name.nil?
    end
    
    def grid_key
      @grid_key ||= "#{owner_type.tableize}/#{owner_id}/#{name}/#{self.file_name}".downcase
    end
    
    def file
      GridFS::GridStore.new(Griddle.database, grid_key, 'r') unless file_name.blank?
    end
    
    def file=(new_file)
      filename = new_file.respond_to?(:original_filename) ? new_file.original_filename : File.basename(new_file.path)
      self.file_name = filename
      self.file_size = File.size(new_file)
      self.content_type = new_file.content_type
      @tmp_file = new_file
    end
    
    def processor
      @processor ||= initialize_processor
    end
    
    def processor= processor
      @attributes[:processor] = processor
      @processor = initialize_processor
    end

    def save
      save_file
      collection.insert(valid_attributes(@attributes).stringify_keys)
    end
    
    def styles
      @styles ||= initialize_styles
    end
    
    def styles= styles
      @attributes[:styles] = styles
      @styles = initialize_styles
    end
    
    def url
      "/griddle/#{grid_key}"
    end

    def valid_attributes(attributes)
      Hash[*attributes.select{|key, value| self.class.valid_attributes.include?(key) }.flatten]
    end
    
    private
    
    def initialize_processor
      Processor.new @attributes[:processor]
    end
    
    def initialize_styles
      return {} unless @attributes[:styles] && @attributes[:styles].is_a?(Hash)
      @attributes[:styles].inject({}) do |h, value|
        h[value.first.to_sym] = Style.new value.first, value.last, self
        h
      end
    end
    
    def save_file
      unless @tmp_file.nil?
        GridFS::GridStore.open(Griddle.database, grid_key, 'w', :content_type => self.content_type) do |f|
          f.write @tmp_file.read
        end
      end
    end
    
    def valid_assignment?(file)
      (file.respond_to?(:original_filename) && file.respond_to?(:content_type))
    end
    
  end
end
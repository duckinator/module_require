class Module
  def module_require(file)
    # TODO: Handle the case where it has already been required.

    prev = Object.constants

    if Object.const_defined?(:Gem)
      Gem.require file
    else
      Kernel.require file
    end

    curr = Object.constants

    new = curr - prev

    new.each do |name|
      self.const_set(name, Object.const_get(name))
      Object.class_eval { remove_const name }

      $LOADED_FEATURES.reject! { |filename| filename =~ %r[/#{name}(/|\.[a-zA-Z0-9]+$)] }
    end

    self
  end
end

module Kernel
  alias :module_require_original_require :require

  def require(file, isolated = false)
    if isolated
      Module.new do
        def self.method_missing(name, *args)
          if self.name.nil? && args.empty?
            name = name.to_s
            name[0] = name[0].capitalize
            name.gsub!(/_([a-z])/) { $1.upcase }
            self.const_get(name)
          else
            super(name, *args)
          end
        end

        module_require(file)
      end
    else
      module_require_original_require(file)
    end
  end
end

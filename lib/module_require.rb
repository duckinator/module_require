require "module_require/version"

class Module
  def module_require(file)
    class_eval open(file).read

    self
  end
end

module Kernel
  alias :module_require_original_require :require

  def require(file, isolated = false)
    $MODULE_REQUIRE_ISOLATED_FILES ||= {}

    if isolated
      $MODULE_REQUIRE_ISOLATED_FILES[file] ||=
        Module.new do
          def self.method_missing(name, *args)
            if self.name.nil? && args.empty?
              name = name.to_s
              name[0] = name[0].capitalize
              name.gsub!(/_([a-z])/) { $1.upcase }
              if self.const_defined?(name)
                return self.const_get(name)
              end
            end

            super(name, *args)
          end

          module_require(file)
        end
    else
      module_require_original_require(file)
    end
  end
end

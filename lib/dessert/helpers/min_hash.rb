module Dessert
  module Helpers
    class MinHash
      class << self
        def get(id, value)
          @coefficient ||= Prime.take(Dessert.config.signiture_size)
          (@coefficient[id] * value + 2 * id) % Dessert.config.minhash_mod
        end
      end
    end
  end
end

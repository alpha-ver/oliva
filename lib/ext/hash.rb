class Hash
  def blank_compact(opts={})
    inject({}) do |new_hash, (k,v)|
      if !v.blank?
        new_hash[k] = opts[:recurse] && v.class == Hash ? v.compact(opts) : v
      end
      new_hash
    end
  end
end
class Hash
  # Returns a new hash with self and other_hash merged recursively.
  #
  def deep_merge(other_hash)
    dup.deep_merge!(other_hash)
  end

  # Returns a new hash with self and other_hash merged recursively.
  # Modifies the receiver in place.
  #
  def deep_merge!(other_hash)
    other_hash.each_pair do |k,v|
      tv = self[k]
      self[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? tv.deep_merge(v) : v
    end
    self
  end

  # Destructively convert all keys to strings.
  #
  def stringify_keys
    dup.stringify_keys!
  end

  # Destructively convert all keys to strings. 
  # Modifies the receiver in place.
  #
  def stringify_keys!
    keys.each do |key|
      self[key.to_s] = delete(key)
    end
    self
  end
end
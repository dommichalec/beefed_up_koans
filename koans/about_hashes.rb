require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutHashes < Neo::Koan
  def test_creating_hashes
    empty_hash = Hash.new
    assert_equal Hash, empty_hash.class
    assert_equal({}, empty_hash)
    assert_equal 0, empty_hash.size
  end

  def test_hash_literals
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.size
    assert_equal [:one, 'uno'], hash.first
  end

  def test_accessing_hashes
    hash = { :one => "uno", :two => "dos" }
    assert_equal 'uno', hash[:one]
    assert_equal 'dos', hash[:two]
    assert_equal nil, hash[:doesnt_exist]
  end

  def test_accessing_hashes_with_fetch
    hash = { :one => 'uno', :two => 'dos', :three => 'tres' }
    assert_equal 'uno', hash.fetch(:one)
    assert_equal 'dos', hash.fetch(:one && :two)
    assert_equal 'uno', hash.fetch(:one || :two)
    assert_raise(KeyError) do
      hash.fetch(:doesnt_exist)
    end
    assert_raise(NameError) do
      hash.fetch(out_of_scope_parameter)
    end
    assert_equal 'Provided key is absent', hash.fetch(:four)  { 'Provided key is absent'}

    # THINK ABOUT IT:
    #
    # Why might you want to use #fetch instead of #[] when accessing hash keys?
    # using Hash#fetch will allow us to catch missing values at first reference
  end

  def test_changing_hashes
    hash = { :one => "uno", :two => "dos" }
    hash[:one] = "eins"

    expected = { :one => 'eins', :two => "dos" }
    assert expected == hash

    # Bonus Question: Why was "expected" broken out into a variable
    # rather than used as a literal?
  end

  def test_hash_is_unordered
    hash1 = { :one => "uno", :two => "dos" }
    hash2 = { :two => "dos", :one => "uno" }

    assert_equal true, hash1 == hash2
  end

  def test_hash_is_unordered_but_does_not_share_object_id
    hash1 = { :one => "uno", :two => "dos" }
    hash2 = { :two => "dos", :one => "uno" }

    assert_equal false, hash1.object_id == hash2.object_id
  end

  def test_hash_is_unordered_but_key_value_pairs_must_match
    hash1 = { :one => "dos", :two => "uno" }
    hash2 = { :two => "dos", :one => "uno" }

    assert hash1 != hash2
  end

  def test_hash_keys
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.keys.size
    assert_equal [:one, :two], hash.keys
    assert :two == hash.keys[1]
    assert true == hash.keys[1].is_a?(Symbol)
    assert_equal true, hash.keys.include?(:one)
    assert_equal true, hash.keys.include?(:two)
    assert false == hash.keys.include?(:five)
    assert_equal Array, hash.keys.class
    assert_equal ['one', 'two'], hash.keys.map(&:to_s)
  end

  def test_hash_values
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.values.size
    assert_equal true, hash.values.include?("uno")
    assert_equal true, hash.values.include?("dos")
    assert_equal Array, hash.values.class
    assert_equal 'dos', hash.values.pop
    assert_equal 'uno', hash.values.delete('uno')
    assert_equal ([]), hash.values.clear
  end

  def test_combining_hashes
    hash = { "jim" => 53, "amy" => 20, "dan" => 23 }
    new_hash = hash.merge({ "jim" => 54, "jenny" => 26 })

    assert_equal true, hash != new_hash

    expected = { "jim" => 54, "amy" => 20, "dan" => 23, "jenny" => 26 }
    assert_equal true, expected == new_hash
  end

  def test_default_value
    hash1 = Hash.new
    hash1[:one] = 1

    assert_equal 1, hash1[:one]
    assert_equal nil, hash1[:two]

    hash2 = Hash.new("dos")
    hash2[:one] = 1

    assert_equal 1, hash2[:one]
    assert_equal 'dos', hash2[:two]
  end

  def test_default_value_is_the_same_object
    hash = Hash.new([])

    hash[:one] << "uno"
    hash[:two] << "dos"

    assert_equal %w(uno dos), hash[:one]
    assert_equal %w(uno dos), hash[:two]
    assert_equal %w(uno dos), hash[:three]

    assert_equal true, hash[:one].object_id == hash[:two].object_id
  end

  def test_default_value_with_block
    hash = Hash.new {|hash, key| hash[key] = [] }

    hash[:one] << "uno"
    hash[:two] << "dos"

    assert_equal %w(uno), hash[:one]
    assert_equal %w(dos), hash[:two]
    assert_equal ([]), hash[:three]
  end
end

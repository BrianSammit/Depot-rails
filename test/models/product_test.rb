require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test 'Product attributes must not be empty' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test 'Product price must be positive' do
    product = Product.new(title: 'My book title',
                          description: 'yyy',
                          image_url: 'zzz.jpg')

    product.price = -1
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(img_url)
    Product.new(title: 'My book title',
                description: 'yyy',
                price: 1,
                image_url: img_url)
  end

  test 'image url' do
    ok = %w[fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif]
    bad = %w[fred.doc fred.gif/more fred.gif.more]

    ok.each do |img_url|
      assert new_product(img_url).valid?, "#{img_url} shouldn't be invalid"
    end

    bad.each do |img_url|
      assert new_product(img_url).invalid?, "#{img_url} shouldn't be valid"
    end
  end

  test 'product is not valid without a unique title' do
    product = Product.new(title: products(:ruby).title,
                          description: 'yyy',
                          price: 1,
                          image_url: 'fred.jpg')

    assert product.invalid?
    assert_equal ['has already been taken'], product.errors[:title]
  end
end

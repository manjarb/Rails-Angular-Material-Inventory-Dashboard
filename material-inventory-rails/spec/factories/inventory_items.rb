FactoryBot.define do
  factory :inventory_item do
    product_number { Faker::Number.number(digits: 8).to_s }
    material { Faker::Commerce.material }
    form { Faker::Commerce.product_name }
    choice { %w[1st\ Choice 2nd\ Choice].sample }
    grade { %w[S235 S355 S460].sample }
    finish { %w[Hot\ Rolled Cold\ Formed Galvanized].sample }
    surface { [nil, 'O', 'P', 'S'].sample }
    quantity { Faker::Number.between(from: 1, to: 100) }
    weight { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    length { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    width { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    height { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    thickness { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    outer_diameter { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    wall_thickness { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    web_thickness { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    flange_thickness { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    certificates { %w[ISO9001 ISO14001 EN10204].sample }
    location { Faker::Address.country_code }
    form_choice { "#{form} #{choice}".strip }
  end
end

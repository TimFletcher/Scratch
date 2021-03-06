
class NormalizeTestModel < ActiveRecord::Base

  normalize(after: :save,
            only:  :foo,
            set:   'foo',
            name:  :normalize_after_save)

  normalize(before: :validation,
            only:   :bar,
            set:    0)

  normalize(trigger: :before_save,
            only:    :baz) do |value|
    value * 2
  end

end

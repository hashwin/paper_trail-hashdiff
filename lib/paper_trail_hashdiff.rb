# frozen_string_literal: true

# Allows storing only incremental changes in the object_changes column
# Uses HashDiff (https://github.com/liufengyun/hashdiff)
class PaperTrailHashDiff
  attr_reader :only_objects

  def initialize(only_objects: false)
    @only_objects = only_objects
  end

  def diff(changes)
    diff_changes = {}
    changes.each do |field, value_changes|
      if (
        !only_objects || (
          value_changes[0] && value_changes[1] &&
          (value_changes[0].is_a?(Hash) || value_changes[0].is_a?(Array))
        )
      )
        diff_changes[field] = Hashdiff.diff(value_changes[0], value_changes[1], array_path: true)
      else
        diff_changes[field] = value_changes
      end
    end
    diff_changes
  end

  def where_object_changes(version_model_class, attributes)
    scope = version_model_class
    attributes.each do |k, v|
      scope = scope.where('(((object_changes -> ?)::jsonb ->> 0)::jsonb @> ?)', k.to_s, v.to_s)
    end
    scope
  end

  def load_changeset(version)
    HashWithIndifferentAccess.new(version.object_changes_deserialized)
  end
end

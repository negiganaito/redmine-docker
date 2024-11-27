# frozen_string_literal: true

class NoteVisibleRole < (defined?(ApplicationRecord) == 'constant' ? ApplicationRecord : ActiveRecord::Base)
  include Redmine::SafeAttributes

  safe_attributes 'note_template_id', 'role_id'
  belongs_to :role
  belongs_to :note_template, optional: true

  validates :role_id, presence: true
  validates :note_template_id, presence: true

  scope :search_by_note_template, lambda { |note_template_id|
    where(note_template_id: note_template_id)
  }
end

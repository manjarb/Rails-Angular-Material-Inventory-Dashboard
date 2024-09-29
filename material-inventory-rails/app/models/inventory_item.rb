class InventoryItem < ApplicationRecord
  before_save :set_form_choice

  private

  def set_form_choice
    self.form_choice = "#{form} #{choice}".strip
  end
end

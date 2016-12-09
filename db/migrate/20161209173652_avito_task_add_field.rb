class AvitoTaskAddField < ActiveRecord::Migration
  def change
    add_column :avito_tasks, :q, :text, default:nil
  end
end

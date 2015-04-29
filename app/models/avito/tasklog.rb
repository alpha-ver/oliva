class Avito::Tasklog < ActiveRecord::Base
  belongs_to :avito_task, :class_name => Avito::Task

end

module ApplicationHelper

  def get_select_options(collection)
    collection.collect{ |i| [i.name, i.id]}
  end

  def to_dos_json(to_dos)
    @to_dos_json = to_dos.to_json(except: %i(updated_datetime))
  end

end

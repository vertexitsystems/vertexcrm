module ApplicationHelper
  
  def contract_types
    ["1099","c2c","w2"]
  end
  
  def merge_params(p={})
    params.merge(p).delete_if{|k,v| v.blank?}
  end
  
  def hello_app(x)
    
    "
    <h3>this is Value from helper<h3>
    <b>#{x}</b>
    
    
    "
  end 

end

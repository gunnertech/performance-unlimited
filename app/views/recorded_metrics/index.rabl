collection :@recorded_metrics
attributes :id, :metric, :recorded_on, :value, :numerical_value
child(:metric) do
  attributes :metric_type, :name
  child(:metric_type){ attributes :name }
end
child(:user) do
  attributes :name, :id
end
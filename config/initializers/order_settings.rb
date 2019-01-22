Rails.configuration.order = {
  short_name: 'Megaband',
  browser_title: 'Portland Megaband Admissions',
  order_form_title: 'megaband admissions & t-shirts',
  order_form_description: 'This is a benefit dance with the goal of raising money for the community grants fund. Please pay as much as you can, between $10 and $25 per admission.',
  admission_cost: 0, # required: number or 0 for sliding scale
  sliding_scale_min: 10, # optional: number or delete line if not sliding scale
  sliding_scale_max: 25, # optional: number or delete line if not sliding scale
  tshirts_available: true, # required: true or false
}

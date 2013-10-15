Spree::Admin::OrdersController.class_eval do
  def export_csv
    created_at_gt = Time.zone.parse(params[:created_at_gt]).beginning_of_day rescue ""
    created_at_lt = Time.zone.parse(params[:created_at_lt]).end_of_day rescue ""

    scope = Spree::Order.completed_between(created_at_gt, created_at_lt).order("created_at")

    scope = scope.paid_and_ready_to_ship unless (params.has_key?(:all_in_window) && params[:all_in_window] == 'true')

    @orders = scope
    send_data @orders.export_csv.encode(SpreeExport.output_encoding, :invalid => :replace, :undef => :replace, :replace => '?'), :filename => csv_filename(:name => 'orders', :date_start => created_at_gt, :date_end => created_at_lt)
  end
end

require_relative "../views/orders_view"
require_relative "../views/meals_view"
require_relative "../views/customers_view"
require_relative "../views/employees_view"

class OrdersController
  def initialize(meal_repo, employee_repo, customer_repo, order_repo)
    @order_repo = order_repo
    @meal_repo = meal_repo
    @customer_repo = customer_repo
    @employee_repo = employee_repo
    @orders_view = OrdersView.new
    @meals_view = MealsView.new
    @customers_view = CustomersView.new
    @employees_view = EmployeesView.new
  end

  def list_undelivered_orders
    undelivered_orders = @order_repo.undelivered_orders
    @orders_view.display(undelivered_orders)
  end

  def add
    meal = select_meal
    customer = select_customer
    employee = select_employee
    order = Order.new(meal: meal, customer: customer)
    employee.add_order(order) # Link employee and order on both sides of the relation
    @order_repo.add(order)
  end

  def list_my_orders(current_user)
    list_my_undelivered_orders(current_user)
  end

  def mark_as_delivered(current_user)
    list_my_undelivered_orders(current_user)
    index = @orders_view.ask_user_for_index
    order = current_user.undelivered_orders[index]
    @order_repo.mark_as_delivered(order)
  end

  private

  def list_my_undelivered_orders(user)
    orders = user.undelivered_orders
    @orders_view.display(orders)
  end

  def select_meal
    meals = @meal_repo.all
    @meals_view.display(meals)
    index = @orders_view.ask_user_for_index
    return meals[index]
  end

  def select_customer
    customers = @customer_repo.all
    @customers_view.display(customers)
    index = @orders_view.ask_user_for_index
    return customers[index]
  end

  def select_employee
    employees = @employee_repo.all_delivery_guys
    @employees_view.display(employees)
    index = @orders_view.ask_user_for_index
    return employees[index]
  end
end

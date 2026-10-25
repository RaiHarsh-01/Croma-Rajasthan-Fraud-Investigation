-- Case File: Who Stole the Profit?
-- Load in SQL Server Management Studio: create or pick an empty database, open this file, press Execute.
-- Tables are created in the current database. Same data the contest uses.


CREATE TABLE stores (
  Store_ID varchar(14) NOT NULL,
  Store_Name varchar(23) NOT NULL,
  City varchar(17) NOT NULL,
  Area varchar(24) NOT NULL,
  Open_Time varchar(15) NOT NULL,
  Close_Time varchar(15) NOT NULL,
  Store_Manager_ID varchar(14) NOT NULL
);


CREATE TABLE employees (
  Emp_ID varchar(14) NOT NULL,
  Emp_Name varchar(25) NOT NULL,
  Role varchar(36) NOT NULL,
  Store_ID varchar(14) NULL,
  Joining_Date date NOT NULL,
  Exit_Date date NULL,
  Registered_Mobile varchar(20) NOT NULL
);
select * from employees;

CREATE TABLE products (
  Product_ID varchar(14) NOT NULL,
  Brand varchar(19) NOT NULL,
  Category varchar(29) NOT NULL,
  Product_Name varchar(53) NOT NULL,
  Selling_Price decimal(12,2) NOT NULL,
  Standard_Cost decimal(12,2) NOT NULL
);

CREATE TABLE campaigns(
  Campaign_Code varchar(19) NOT NULL,
  Campaign_Name varchar(33) NOT NULL,
  Start_Date date NOT NULL,
  End_Date date NOT NULL,
  Max_Discount_Pct decimal(5,2) NOT NULL,
  Applies_To varchar(24) NOT NULL
);

CREATE TABLE sales (
  Invoice_ID varchar(20) NOT NULL,
  Invoice_Date date NOT NULL,
  Invoice_Time varchar(15) NOT NULL,
  Store_ID varchar(14) NOT NULL,
  Store_Name varchar(23) NOT NULL,
  Sales_Person_ID varchar(14) NULL,
  Product_ID varchar(14) NOT NULL,
  Quantity int NOT NULL,
  Unit_Price decimal(12,2) NOT NULL,
  Discount_Pct decimal(5,2) NOT NULL,
  Campaign_Code varchar(19) NULL,
  Net_Amount decimal(14,2) NOT NULL,
  Payment_Mode varchar(14) NOT NULL,
  Customer_Mobile varchar(20) NULL,
  Card_Last4 varchar(14) NULL
);
select distinct(Sales_Person_ID) from sales; group by Sales_Person_ID;

CREATE TABLE refunds (
  Refund_ID varchar(17) NOT NULL,
  Invoice_ID varchar(20) NOT NULL,
  Store_ID varchar(14) NOT NULL,
  Refund_Date date NOT NULL,
  Refund_Time varchar(15) NOT NULL,
  Refund_Amount decimal(14,2) NOT NULL,
  Reason varchar(32) NOT NULL,
  Item_Returned varchar(13) NOT NULL,
  Refund_Mode varchar(14) NOT NULL,
  Refund_To varchar(26) NOT NULL,
  Processed_By varchar(14) NULL
);

CREATE TABLE purchases (
  PO_ID varchar(17) NOT NULL,
  PO_Date date NOT NULL,
  Supplier varchar(39) NOT NULL,
  Product_ID varchar(14) NOT NULL,
  Store_ID varchar(14) NOT NULL,
  Quantity int NOT NULL,
  Unit_Cost decimal(12,2) NOT NULL,
  Total_Cost decimal(14,2) NOT NULL,
  Approved_By varchar(14) NOT NULL,
  Co_Approved_By varchar(10) NULL
);



select count(*) from stores;
select count(*) from refunds;
select count(*) from employees;
select count(*) from sales;
select count(*) from purchases;
select count(*) from campaigns;
select count(*) from products;

SELECT * FROM sales LIMIT 9;
SELECT * FROM refunds where item_returned = 'No';
select * from stores;
select * from employees;

Qus-1
For each store, return store_name, total_sales, total_refunds and refund_pct.
total_sales = sum of Net_Amount in sales
total_refunds = sum of Refund_Amount in refunds (0 if a store has none)
refund_pct = refunds ÷ sales × 100, rounded to 2 decimals
Order by refund_pct descending.

Sol-
select s.store_name, sum(s.Net_Amount) as total_sales, sum(r.Refund_Amount) as 
total_refunds, round(sum(r.Refund_Amount)/sum(s.Net_Amount)*100,2) as refund_pct
from sales s join refunds r on s.Store_ID = r.Store_ID group by s.Store_name 
order by refund_pct desc;

Qus-2
Return refunds month by month for every store: store_name, month (text yyyy-mm, for example 2025-09), refund_count, 
refund_amount. Order by store, then month.

Sol-
select s.store_name, extract(month from r.Refund_Date) as refund_month, 
count(r.refund_id) as refund_count, sum(r.Refund_Amount) as refund_amount
from stores s join refunds r on s.Store_ID = r.Store_ID group by 
s.store_name, extract(month from r.Refund_Date) order by s.store_name, refund_month;

Qus-3
Using the refund policy, find every refund that breaks at least one rule. Compare each refund with its original sale:
R1: more than 10 days between sale and refund
R2: refund mode different from the sale's payment mode
R3: refund time before the store's opening time or after its closing time
R4: item not returned (Item_Returned is not Yes)
Leave out refunds that have no matching sale or no processor.
Return processed_by, employee_name, refund_count, refund_amount and paid_to (where the money went, Refund_To), grouped by
processor and destination. Order by refund_amount descending.

Sol-
PostgreSQL
select r.processed_by, e.emp_name, count(r.refund_id) as refund_count, sum(r.refund_amount) as refund_amount, r.refund_to
from refunds r join sales s on r.Invoice_ID = s.Invoice_ID join stores t on s.store_id = t.store_id join employees e on
e.Emp_ID = r.Processed_By where (r.refund_date::date - s.invoice_date::date) > 10 or 
s.payment_mode != r.refund_mode or r.refund_time < t.open_time or r.refund_time > t.close_time or r.item_returned = 'No'
group by r.processed_by, r.refund_to, e.emp_name order by refund_amount desc;

SQLserver
select  r.processed_by, e.emp_name,  count(r.refund_id) as refund_count, sum(r.refund_amount) as refund_amount, r.refund_to
from refunds r join sales s on r.Invoice_ID = s.Invoice_ID 
join stores t on s.store_id = t.store_id 
join employees e on e.Emp_ID = r.Processed_By 
where DATEDIFF(day, s.invoice_date, r.refund_date) > 10 or s.payment_mode != r.refund_mode or r.refund_time < t.open_time 
   or r.refund_time > t.close_time or r.item_returned = 'No' group by r.processed_by, e.emp_name, r.refund_to 
order by refund_amount desc;

---refund_date(refunds)-invoice_date(sale) > 10
--payment_mode(sale) != refund_mode
--refund_time < open_time OR refund_time(refunds) > close_time(Store)
--item_returned(refunds) is not Yes


Qus-4
For the rule-breaking refunds (as in T4) processed by the culprit, return month (yyyy-mm) and 
amount_stolen, plus a final total row with month = 'Total'. Order by month, with the total last.

Sol:- PostgreSQL
with df as(select r.processed_by, e.emp_name, count(r.refund_id) as refund_count, sum(r.refund_amount) as refund_amount, 
sum(s.Net_Amount) as net_sale,r.refund_to from refunds r join sales s on r.Invoice_ID = s.Invoice_ID join stores t on 
e.Emp_ID = r.Processed_By join employees e on e.Store_ID = t.store_id where (r.refund_date::date - s.invoice_date::date) > 10 
or s.payment_mode != r.refund_mode or r.refund_time < t.open_time or r.refund_time > t.close_time or r.item_returned = 'No'
group by r.processed_by, e.emp_name, r.refund_to)

select TO_CHAR(refund_date, 'YYYY-MM')  as mon ,sum(refund_amount) from refunds where refund_to in 
(select refund_to from df) group by TO_CHAR(refund_date, 'YYYY-MM') order by mon asc;

--SQL Server
with harsh as (
    select  r.processed_by, e.emp_name,  count(r.refund_id) as refund_count, sum(r.refund_amount) as refund_amount, r.refund_to
from refunds r join sales s on r.Invoice_ID = s.Invoice_ID 
join stores t on s.store_id = t.store_id 
join employees e on e.Emp_ID = r.Processed_By 
where DATEDIFF(day, s.invoice_date, r.refund_date) > 10 or s.payment_mode != r.refund_mode or r.refund_time < t.open_time 
   or r.refund_time > t.close_time or r.item_returned = 'No' group by r.processed_by, e.emp_name, r.refund_to 
order by refund_amount desc;
)

select format(r.refund_date, 'yyyy-MM') as mon, sum(r.refund_amount) as total_refund_amount
from refunds r where r.refund_to in (select refund_to from harsh)
group by FORMAT(r.refund_date, 'yyyy-MM') order by mon asc;


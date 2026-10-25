# Croma-Rajasthan-Fraud-Investigation
Case Overview: Croma Rajasthan Fraud Investigation  In FY 2025–26, Croma’s four Rajasthan stores achieved record-high sales, yet profits were drastically low. External auditors failed to find the missing funds. Believing an insider is stealing, Regional Business Head Mr. Suresh Sharma has provided a full year of records for analysis.

Your mission
1. Find who took the money.
2. Prove how they did it.
3. Work out how much they took.
4. Recommend how to stop it happening again.

The suspects
Only one is guilty. Some of the others only look guilty.

Suspect	Role	Why Mr. Sharma suspects them
Vikram Rathore (E180)	Store Manager, Croma Udaipur	His store's sales fell sharply in August
Neha Kapoor (E112)	Sales Executive, Croma Jaipur	She gives the highest discounts in the region
Arjun Mehta (E301)	Purchase Head	He approves every purchase, and purchase costs went up
Rohit Saini (E207)	Customer Service Executive, Croma Jodhpur	He joined mid-year and handles refunds
Shree Ganesh Distributors	Supplier	Rumoured to be overcharging the company

Company policies
A fraud is usually a broken rule. Read these carefully.

Refund policy
R1. A refund can be issued only within 10 days of the original sale.
R2. The refund must go back by the original payment mode: cash to cash, card to the same card, UPI to the customer's UPI ID.
R3. Refunds can be processed only during store hours (see stores).
R4. The item must be returned before a refund is issued (Item_Returned = 'Yes').
R5. Refunds are processed by the store's Customer Service Executive (see notice N2).

Discount policy
D1. A sales executive may give up to 10% discount without approval.
D2. Discounts above 10% need a valid Campaign_Code, within the campaign dates and up to its maximum.

Purchase policy
P1. All purchase orders are approved by the Purchase Head.
P2. Purchase orders above Rs 10 lakh also need Regional Head co-approval.
P3. Suppliers bill at the agreed rate, which is the product's Standard_Cost.

Notices sent during the year
N1 (01-08-2025): Croma Udaipur closed for renovation, 8 to 24 August 2025.
N2 (25-08-2025): Store managers may process refunds when the customer service desk is unstaffed. R1 to R4 still apply.
N3 (20-09-2025): Croma Festive Sale, 1 Oct to 10 Nov 2025, up to 20% with code CMP-FES25.
N4 (30-09-2025): Sanjay Purohit (E209), CS Executive at Croma Jodhpur, has left. Rohit Saini (E207) joins on 6 Oct 2025.
N5 (15-01-2026): Croma Republic Day Sale, 20 to 31 Jan 2026, up to 15% with code CMP-RD26.

How the tables connect
1. refunds.invoice_id → sales.invoice_id
2. refunds.processed_by and sales.sales_person_id → employees.emp_id
3. product_id → products, store_id → stores, campaign_code → campaigns

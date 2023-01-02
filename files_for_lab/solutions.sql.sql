#1. Get the id values of the first 5 clients from district_id with a value equals to 1.
#2. In the client table, get an id value of the last client where the district_id equals to 72.
#3. Get the 3 lowest amounts in the loan table.
#4. What are the possible values for status, ordered alphabetically in ascending order in the loan table?
#5. What is the loan_id of the highest payment received in the loan table?
#6. What is the loan amount of the lowest 5 account_ids in the loan table? Show the account_id and the corresponding amount
#7. What are the account_ids with the lowest loan amount that have a loan duration of 60 in the loan table?
#8. What are the unique values of k_symbol in the order table?
#9. In the order table, what are the order_ids of the client with the account_id 34?
#10. In the order table, which account_ids were responsible for orders between order_id 29540 and order_id 29560 (inclusive)?
#11. In the order table, what are the individual amounts that were sent to (account_to) id 30067122?
#12. In the trans table, show the trans_id, date, type and amount of the 10 first transactions from account_id 793 in chronological order, from newest to oldest.
#13. In the client table, of all districts with a district_id lower than 10, how many clients are from each district_id? Show the results sorted by the district_id in ascending order.
#14. In the card table, how many cards exist for each type? Rank the result starting with the most frequent type.
#15. Using the loan table, print the top 10 account_ids based on the sum of all of their loan amounts.
#16. In the loan table, retrieve the number of loans issued for each day, before (excl) 930907, ordered by date in descending order.
#17. In the loan table, for each day in December 1997, count the number of loans issued for each unique loan duration, ordered by date and duration, both in ascending order. You can ignore days without any loans in your output.
#18. In the trans table, for account_id 396, sum the amount of transactions for each type (VYDAJ = Outgoing, PRIJEM = Incoming). Your output should have the account_id, the type and the sum of amount, named as total_amount. Sort alphabetically by type.
#19. From the previous output, translate the values for type to English, rename the column to transaction_type, round total_amount down to an integer
#20. From the previous result, modify your query so that it returns only one row, with a column for incoming amount, outgoing amount and the difference.
#21. Continuing with the previous example, rank the top 10 account_ids based on their difference.
use bank;

#01
select client_id from client where district_id = 1 limit 5;
#02
select client_id from client where district_id = 72 order by client_id desc limit 1;
#03
select amount from loan order by amount asc limit 3;
#04
select distinct status from loan order by status asc;
#05
select loan_id from loan order by payments asc limit 1;
#07
select account_id as id, amount from loan order by 1 asc limit 5;
#08
select account_id from loan where duration = 60 order by amount asc limit 5;
#09
select distinct k_symbol from `order`;
#10
select order_id from `order` where account_id = 34;
#11
select account_id from `order`where order_id >= 29540 and order_id <= 29560;
#12
select amount from `order` where account_to = 30067122;
#13
select trans_id, date, type, amount from trans where account_id = 793 order by date desc limit 10;
#14
select district_id, count(client_id) from client where district_id < 10 
group by district_id order by district_id asc;
#15
select type, count(card_id) number_of_cards from card group by type order by 2 desc;
#16
select account_id, sum(amount) as sum_loan from loan where date < 930907 group by date
order by date desc;
#17
select date, duration, count(loan_id) as total_loans from loan where date like '9712%' 
and amount <> '' group by 1, 2 order by 1, 2;
#18
select acount_id, type, sum(amount) as total_amount from trans where account_id = 396
group by 2 order by 2;
#19
select account_id, if(type = 'PRIJEM', 'Incoming', 'Outgoing') as transaction_type, round(sum(amount)) 
as total_amount from trans where account_id = 396 group by 2 order by 2;
#20
select account_id, ceiling(sum(if(type = 'PRIJEM', amount, '0'))) as incoming,
ceiling(sum(IF(type = 'VYDAJ', amount, 0))) as outgoing,
ceiling(ceiling(sum(if(type = 'PRIJEM', amount, 0))) - ceiling(sum(if(type = 'VYDAJ', amount, 0)))) as difference
from trans where account_id = 396;
#21
select account_id, abs(ceiling(sum(if(type = 'PRIJEM', amount, 0)) - sum(if(type = 'VYDAJ', amount, 0)))) AS difference
from trans group by 1 order by 2 desc limit 10;
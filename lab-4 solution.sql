use `order-directory`;

/*
Answer-3
*/
select count(a2.cus_gender) as NoOfCustomers, a2.cus_gender from
(select a1.cus_id, a1.cus_gender, a1.ord_amount, a1.cus_name from
(select `order`.ord_amount, `order`.cus_id,customer.cus_gender, customer.cus_name 
from `order` 
inner join 
customer 
on `order`.cus_id=customer.cus_id 
having `order`.ord_amount>=3000)
as a1 
group by a1.cus_id) as a2
group by a2.cus_gender;

/*
Answer-4
*/

select `order`.*, a1.pro_name from `order`
inner join
(select product.pro_name, supplier_pricing.pricing_id from product
inner join supplier_pricing 
on
supplier_pricing.pro_id = product.pro_id ) as a1
on
`order`.pricing_id = a1.pricing_id where `order`.cus_id=2;

select product.pro_name, `order`.* from `order`, supplier_pricing, product
where `order`.cus_id=2 and
`order`.pricing_id=supplier_pricing.pricing_id and supplier_pricing.pro_id=product.pro_id;

/*
Answer-5
*/

select supplier.* from supplier where supplier.supp_id in
(select supp_id from supplier_pricing group by supp_id having
count(supp_id)>1);


/*
ANSWER-6
*/

select category.cat_id,category.cat_name, min(a2.min_price) as Min_Price,
a2.pro_name from 
category 
inner join
(select product.cat_id, product.pro_name, a1.* from product inner join
(select pro_id, min(supp_price) as Min_Price from supplier_pricing group by pro_id)
as a1 
where a1.pro_id = product.pro_id)as a2
where a2.cat_id = category.cat_id group by a2.cat_id;

/*
ANSWER-7
*/
select product.pro_id,product.pro_name from 
`order` 
inner join 
supplier_pricing 
on supplier_pricing.pricing_id=`order`.pricing_id 
inner join 
product
on 
product.pro_id=supplier_pricing.pro_id where `order`.ord_date>"2021-10-05";

/*
ANSWER-8
*/
select cus_name,cus_gender from customer 
where cus_name like 'A%' or cus_name like '%A';

/*
ANSWER-9
*/
select report.supp_id,report.supp_name,report.Average,
CASE
WHEN report.Average =5 THEN 'Excellent Service'
WHEN report.Average >4 THEN 'Good Service'
WHEN report.Average >2 THEN 'Average Service'
ELSE 'Poor Service'
END AS Type_of_Service from
(select final.supp_id, supplier.supp_name, final.Average from
(select test2.supp_id, avg(test2.rat_ratstars) as Average from
(select supplier_pricing.supp_id, test.ORD_ID, test.RAT_RATSTARS from 
supplier_pricing inner join
(select `order`.pricing_id, rating.ORD_ID, rating.RAT_RATSTARS from 
`order` 
inner join 
rating 
on rating.`ord_id` = `order`.ord_id ) 
as test
on test.pricing_id = supplier_pricing.pricing_id)
as test2 group by supplier_pricing.supp_id)
as final 
inner join 
supplier 
where final.supp_id = supplier.supp_id) as report;

call output();


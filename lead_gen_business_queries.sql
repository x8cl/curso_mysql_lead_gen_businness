#1. ¿Qué consulta ejecutaría para obtener los ingresos totales para marzo de 2012?
select monthname(charged_datetime) as month, sum(amount)as revenue
from billing
where charged_datetime >= "2012-03-01" and charged_datetime < "2012-04-01";

#2. ¿Qué consulta ejecutaría para obtener los ingresos totales recaudados del cliente con una identificación de 2?
select client_id, sum(amount)as total_revenue
from billing
where client_id = 2;

#3. ¿Qué consulta ejecutaría para obtener todos los sitios que posee client = 10?
select domain_name as website, client_id
from sites
where client_id = 10;

#4. ¿Qué consulta ejecutaría para obtener el número total de sitios creados por mes por año
# para el cliente con una identificación de 1? ¿Qué pasa con el cliente = 20?
select client_id, count(domain_name) as number_of_websites, monthname(created_datetime) as month_created, year(created_datetime) as year_created
from sites
where client_id = 20
group by year_created, month_created
order by year_created, month_created;

#5. ¿Qué consulta ejecutaría para obtener el número total de clientes potenciales generados para cada uno de los sitios
# entre el 1 de enero de 2011 y el 15 de febrero de 2011?
select sites.domain_name as website, count(leads.site_id) as number_of_leads, date_format(leads.registered_datetime, "%M %d, %Y") as date_generated
from leads
join sites on sites.site_id = leads.site_id
where leads.registered_datetime >= "2011-01-01" and leads.registered_datetime < "2011-02-12"
group by sites.site_id
order by leads.registered_datetime;

#6. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes
# y el número total de clientes potenciales que hemos generado para cada uno de nuestros clientes
# entre el 1 de enero de 2011 y el 31 de diciembre de 2011?
select concat(clients.first_name," ", clients.last_name) as client_name, count(leads.site_id) as number_of_leads
from clients
left join sites on sites.client_id = clients.client_id
left join leads on leads.site_id = sites.site_id
where leads.registered_datetime >= "2011-01-01" and leads.registered_datetime < "2012-01-01"
group by clients.client_id;

#7. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes potenciales
# que hemos generado para cada cliente cada mes entre los meses 1 y 6 del año 2011?
select concat(clients.first_name," ", clients.last_name) as client_name, count(leads.site_id) as number_of_leads, date_format(leads.registered_datetime, "%M") as month_generated
from clients
left join sites on sites.client_id = clients.client_id
left join leads on leads.site_id = sites.site_id
where leads.registered_datetime >= "2011-01-01" and leads.registered_datetime < "2011-07-01"
group by clients.client_id, month_generated
order by month(leads.registered_datetime);

#8.1. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes potenciales
# que hemos generado para cada uno de los sitios de nuestros clientes entre el 1 de enero de 2011 y el 31 de diciembre de 2011?
# Solicite esta consulta por ID de cliente.
select concat(clients.first_name, " ", clients.last_name) as client_name, sites.domain_name as website, count(leads.site_id) as number_of_leads, date_format(leads.registered_datetime, "%M %d, %Y") as date_generated
from clients
left join sites on sites.client_id = clients.client_id
left join leads on leads.site_id = sites.site_id
where leads.registered_datetime >= "2011-01-01" and leads.registered_datetime < "2012-01-01"
group by clients.client_id, sites.site_id;

#8.2. Presente una segunda consulta que muestre todos los clientes, los nombres del sitio
# y el número total de clientes potenciales generados en cada sitio en todo momento.
select concat(clients.first_name, " ", clients.last_name) as client_name, sites.domain_name as website, count(leads.site_id) as number_of_leads
from clients
left join sites on sites.client_id = clients.client_id
left join leads on leads.site_id = sites.site_id
group by clients.client_id, sites.site_id;

#9. Escriba una sola consulta que recupere los ingresos totales recaudados de cada cliente para cada mes del año.
# Pídalo por ID de cliente.
select concat(clients.first_name, " ", clients.last_name) as client_name, sum(billing.amount) as Total_Revenue, date_format(billing.charged_datetime, "%M") as month_charge, year(billing.charged_datetime) as year_charge
from clients
left join billing on billing.client_id = clients.client_id
group by clients.client_id, month_charge, year_charge
order by clients.client_id, billing.charged_datetime;

#10. Escriba una sola consulta que recupere todos los sitios que posee cada cliente.
# Agrupe los resultados para que cada fila muestre un nuevo cliente.
# Se volverá más claro cuando agregue un nuevo campo llamado 'sitios' que tiene todos los sitios que posee el cliente.
# (SUGERENCIA: use GROUP_CONCAT)
select concat(clients.first_name, " ", clients.last_name) as client_name, group_concat(sites.domain_name separator " / ") as sites
from clients
left join sites on sites.client_id = clients.client_id
group by clients.client_id;
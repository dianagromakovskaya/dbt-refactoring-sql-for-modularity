{% macro limit_data_in_dev(column_name, dev_days_of_data) %}
{% if target.name == 'dev' %}
where {{ column_name }} >= date_add(current_datetime, interval -{{ dev_days_of_data }} day)
{% endif %}
{% endmacro %}
{#  
    -- let's develop a macro that 
    1. queries the information schema of a database
    2. finds objects that are > 1 week old (no longer maintained)
    3. generates automated drop statements
    4. has the ability to execute those drop statements

#}

{% macro clean_stale_models(database=target.project, schema=target.dataset, days=10, dry_run=True) %}
    
    {% set get_drop_commands_query %}
        select
            'DROP TABLE' || ' {{ database }}.' || dataset_id || '.' || table_id || ';'
        from {{ database }}.{{ schema }}.__TABLES__ 
        where dataset_id = '{{ schema }}'
        and datetime(timestamp_millis(last_modified_time)) <= datetime_sub(current_datetime(), interval {{ days }} day)
    {% endset %}

    {{ log('\nGenerating cleanup queries...\n', info=True) }}
    {% set drop_queries = run_query(get_drop_commands_query).columns[0].values() %}

    {% for query in drop_queries %}
        {% if dry_run %}
            {{ log(query, info=True) }}
        {% else %}
            {{ log('Dropping object with command: ' ~ query, info=True) }}
            {% do run_query(query) %} 
        {% endif %}       
    {% endfor %}
    
{% endmacro %} 
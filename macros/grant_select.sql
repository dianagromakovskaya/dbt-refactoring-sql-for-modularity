{% macro grant_select(project=target.project, schema=target.dataset, user='user:dbt-user@your-project.iam.gserviceaccount.com') %}
    {% set sql %} 
        grant `roles/bigquery.dataViewer` on schema `{{ project }}.{{ schema }}` to "{{ user }}";
    {% endset %}

    {{ log('Granting select on all tables and views in schema ' ~ target.dataset ~ ' to user ' ~ user, info=True) }}
    {% do run_query(sql) %}
    {{ log('Privileges granted', info=True) }}

{% endmacro %}
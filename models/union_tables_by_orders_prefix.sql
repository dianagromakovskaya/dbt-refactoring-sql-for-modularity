{{ union_tables_by_prefix(

      database=target.project,
      schema=target.dataset, 
      prefix='my_'
        
      )
      
  }}
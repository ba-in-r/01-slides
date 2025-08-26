## Eduard Martinez
## R version 4.5.0

####== 1. Configuracion Inicial

## limpiar entorno
rm(list=ls())

## llamar/instalar librerias
require(pacman)
p_load(dplyr , ggplot2 , skimr , rio)

## load data
db <- import("03_combine_data/output/data_long.rds")
df <- db %>%
  subset(time==1) %>%
  mutate(win_v1=ifelse(order_pdte_v1==1 , name_pdte , name_other_v1) , 
         win_v2=ifelse(order_pdte_v2==1 , name_pdte , name_other_v2) ,
         votos_win_v1=ifelse(order_pdte_v1==1 , v_pdte_v1 , v_other_v1) , 
         votos_win_v2=ifelse(order_pdte_v2==1 , v_pdte_v2 , v_other_v2) ,
         votos_v1=v_total_v1 , 
         votos_v2=v_total_v2 ,
         votos_diff_v1=abs(v_diff_v1),
         votos_diff_v2=abs(v_diff_v2),
         conteo=1) %>% 
  select(area_m,mpio_name,place_id,year_e,votos_v1,votos_v2,win_v1,win_v2,votos_win_v1,votos_win_v2,votos_diff_v1,votos_diff_v2)
export(df,"../../../OneDrive-Universidaddelosandes/BA3 - Introducción a Business Analitycs/02_github/01-slides/week-05/data/Votaciones.rds")

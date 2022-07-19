#!/bin/bash

types=(app db reddit) #Задать массив для группировки из названия ВМ
types_ungr=$(echo ${types[*]} | sed 's/ /|/g') #Преобразование массива для поиска ВМ, не входящих в группы

yc_list () {
    yc compute instance list --format json
}

#Вывод ВМ, входящих в группы
print_group_hosts() {
  echo "  \"$type\": {"
  echo "    \"hosts\": ["
  yc_list | \
    jq --arg t "$type" '.[] | select(.name | contains($t)) | .network_interfaces[].primary_v4_address.one_to_one_nat.address' | \
    sed '$!s/$/,/;s/^/      /'
  echo "    ]"
  echo "  }"
}

#Вывод всех ВМ
print_all_hosts() {
  echo "  \"hosts\": ["
  yc_list | \
    jq '.[] | .network_interfaces[].primary_v4_address.one_to_one_nat.address' | \
    sed '$!s/$/,/;s/^/    /'
  echo "  ]"
}

#Вывод ВМ, не входящих в группы массива
print_ungrouped_hosts() {
  echo "  \"hosts\": ["
  yc_list | \
    jq --arg t "$types_ungr" '.[] | select(.name | test($t) | not) | .network_interfaces[].primary_v4_address.one_to_one_nat.address' | \
    sed '$!s/$/,/;s/^/      /'
  echo "  ]"
}

#Вывод всей инфы
print_all () {
  echo "{"
  #Если массив пустой - выводим все вм
  if [ ${#types[@]} -eq 0 ]; then
    print_all_hosts
  else
  #Если массив задан - группы, потом вне групп
      for type in ${types[*]}
      do
        print_group_hosts
      done
      print_ungrouped_hosts
  fi
  echo "}"
}

#Выводим, добавляем запятые
print_all | sed -z 's/}\n  "/},\n  "/g'

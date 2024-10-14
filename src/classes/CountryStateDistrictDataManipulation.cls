public with sharing class CountryStateDistrictDataManipulation {
  public static Map<String, Map<String, List<String>>> mapOfCountryStateAndListOfDistricts = new Map<String, Map<String, List<String>>>();

  public CountryStateDistrictDataManipulation() {
    mapOfCountryStateAndListOfDistricts = fillCountryStateAndDistrictMap('s');
    //Calling Rollup Methods
    List<State__c> updatedListOfStates = rollUpStateAndDistrict();
    List<Country__c> updatedListOfCountries = rollUpCountryAndState();
    JSONDataGeneratorForSpecificCountry('India');
  }

  public static Map<String, Map<String, List<String>>> fillCountryStateAndDistrictMap(
    String word
  ) {
    /*Map<Id, Country__c> mapOfCountries = new Map<Id, Country__c>([
            Select Id, Name, Total_Number_of_States__c, Total_Number_of_Districts__c 
            From Country__c
        ]);
        Map<Id, State__c> mapOfStates = new Map<Id, State__c>([
            Select Id, Name, Country_Name__c, Total_Number_of_Districts__c 
            From State__c
        ]);
        Map<Id, District__c> mapOfDistricts = new Map<Id, District__c>([
            Select Id, Name, State_Name__c 
            From District__c
        ]);

        for(Country__c country: mapOfCountries.values()){
            if(!mapOfCountryStateAndListOfDistricts.containsKey(country.Name)){
                mapOfCountryStateAndListOfDistricts.put(country.Name, new Map<String, List<String>>());

                for(State__c state: mapOfStates.values()){
                    if(mapOfCountryStateAndListOfDistricts.containsKey(
                        mapOfCountries.get(state.Country_Name__c).Name)){
                        mapOfCountryStateAndListOfDistricts.get(mapOfCountries.get(state.Country_Name__c).Name).put(
                            state.Name, new List<String>());
                        for(District__c district: mapOfDistricts.values()){
                            if(mapOfCountryStateAndListOfDistricts.get(mapOfCountries.get(state.Country_Name__c).Name).containsKey(
                                mapOfStates.get(district.State_Name__c).Name)){
                                if(!mapOfCountryStateAndListOfDistricts.get(mapOfCountries.get(state.Country_Name__c).Name).get(
                                    mapOfStates.get(district.State_Name__c).Name).contains(district.Name)){
                                        mapOfCountryStateAndListOfDistricts.get(mapOfCountries.get(state.Country_Name__c).Name).get(
                                            mapOfStates.get(district.State_Name__c).Name).add(district.Name);
                                }
                            }
                        }
                    }			
                }
            }
        }
        System.debug(mapOfCountryStateAndListOfDistricts);*/

    List<District__c> districtList = [
      SELECT Name, State_Name__r.Name, State_Name__r.Country_Name__r.Name
      FROM District__c
    ];

    if (!districtList.isEmpty()) {
      for (District__c district : districtList) {
        if (
          !mapOfCountryStateAndListOfDistricts.containsKey(
            district.State_Name__r.Country_Name__r.Name
          )
        ) {
          mapOfCountryStateAndListOfDistricts.put(
            district.State_Name__r.Country_Name__r.Name,
            new Map<String, List<String>>()
          );
        }
        if (
          !mapOfCountryStateAndListOfDistricts.get(
              district.State_Name__r.Country_Name__r.Name
            )
            .containsKey(district.State_Name__r.Name)
        ) {
          mapOfCountryStateAndListOfDistricts.get(
              district.State_Name__r.Country_Name__r.Name
            )
            .put(district.State_Name__r.Name, new List<string>());
        }
        if (
          !mapOfCountryStateAndListOfDistricts.get(
              district.State_Name__r.Country_Name__r.Name
            )
            .get(district.State_Name__r.Name)
            .contains(district.Name)
        ) {
          mapOfCountryStateAndListOfDistricts.get(
              district.State_Name__r.Country_Name__r.Name
            )
            .get(district.State_Name__r.Name)
            .add(district.Name);
          if (
            district.State_Name__r.Country_Name__r.Name.startsWithIgnoreCase(
              word
            )
          ) {
            if (district.State_Name__r.Name.startsWithIgnoreCase(word)) {
              if (district.Name.startsWithIgnoreCase(word)) {
                //listOfCountryStateDistrict.add(district.State_Name__r.Country_Name__r.Name + ' - ' + district.State_Name__r.Name + ' - ' + district.Name);
                System.debug(
                  district.State_Name__r.Country_Name__r.Name +
                    ' - ' +
                    district.State_Name__r.Name +
                    ' - ' +
                    district.Name
                );
              }
            }
          }
        }
      }
    }
    System.debug('Mappp -> ' + mapOfCountryStateAndListOfDistricts);

    return mapOfCountryStateAndListOfDistricts;
  }

  public static void JSONDataGeneratorForSpecificCountry(String countryName) {
    Country__c country = [
      SELECT
        Name,
        Total_Number_of_Districts__c,
        Total_Number_of_States__c,
        Country_Code__c,
        Country_JSON_Data__c
      FROM Country__c
      WHERE Name = :CountryName
      LIMIT 1
    ];

    if (country != null) {
      CountryStateJSONGenerator.Country countryWrapper = new CountryStateJSONGenerator.Country();
      countryWrapper.countryName = country.Name;
      countryWrapper.countryCode = (Integer) country.Country_Code__c;
      countryWrapper.totalStatesNumber = (Integer) country.Total_Number_of_States__c;
      countryWrapper.totalDistricts = (Integer) country.Total_Number_of_Districts__c;

      List<CountryStateJSONGenerator.States> states = new List<CountryStateJSONGenerator.States>();
      if (
        !mapOfCountryStateAndListOfDistricts.get(CountryName).keySet().isEmpty()
      ) {
        for (
          String state : mapOfCountryStateAndListOfDistricts.get(CountryName)
            .keySet()
        ) {
          CountryStateJSONGenerator.States statesWrapper = new CountryStateJSONGenerator.States();
          statesWrapper.stateName = state;
          List<CountryStateJSONGenerator.Districts> Districts = new List<CountryStateJSONGenerator.Districts>();
          if (
            !mapOfCountryStateAndListOfDistricts.get(CountryName)
              .get(state)
              .isEmpty()
          ) {
            for (
              String dis : mapOfCountryStateAndListOfDistricts.get(CountryName)
                .get(state)
            ) {
              CountryStateJSONGenerator.Districts District = new CountryStateJSONGenerator.Districts();
              District.disctirctName = dis;
              Districts.add(District);
            }
          }
          statesWrapper.districts = Districts;
          states.add(statesWrapper);
        }
      }

      countryWrapper.states = states;

      System.debug(countryWrapper);
      System.debug(JSON.serialize(countryWrapper));

      country.Country_JSON_Data__c = JSON.serialize(countryWrapper);
      update country;
    }
  }

  public static List<State__c> rollUpStateAndDistrict() {
    List<State__c> listOfStates = new List<State__c>();

    List<AggregateResult> aggResult = [
      SELECT State_Name__r.Id, COUNT(Id) Total_District
      FROM District__c
      GROUP BY State_Name__r.Id
    ];

    for (AggregateResult agg : aggResult) {
      Id stateId = (Id) agg.get('Id');
      Integer districtCount = (Integer) agg.get('Total_District');
      State__c stateRecord = new State__c();
      stateRecord.Id = stateId;
      stateRecord.Total_Number_of_Districts__c = districtCount;
      listOfStates.add(stateRecord);
    }
    if (!listOfStates.isEmpty()) {
      update listOfStates;
    }
    return listOfStates;
  }

  public static List<Country__c> rollUpCountryAndState() {
    List<Country__c> listOfCountries = new List<Country__c>();

    List<AggregateResult> aggResult = [
      SELECT
        Country_Name__r.Id,
        Count(Id) Total_States,
        Sum(Total_Number_of_Districts__c) Total_Districts
      FROM State__c
      GROUP BY Country_Name__r.Id
    ];

    for (AggregateResult agg : aggResult) {
      Id countryId = (Id) agg.get('Id');
      Decimal districtCount = (Decimal) agg.get('Total_Districts');
      Decimal stateCount = (Decimal) agg.get('Total_States');

      Country__c countryRecord = new Country__c();
      countryRecord.Id = countryId;
      countryRecord.Total_Number_of_Districts__c = districtCount;
      countryRecord.Total_Number_of_States__c = stateCount;
      listOfCountries.add(countryRecord);
    }

    if (!listOfCountries.isEmpty()) {
      update listOfCountries;
    }

    return listOfCountries;
  }
}

public with sharing class ApexExpressionOperators {
  public static void apexExpression() {
    System.debug(1 + 1); //literal expression
    //** A new sObject, Apex object, list, set, or map. For example:
    Account acc = new Account();
    Integer inti = 5;
    List<Account> account = new List<Account>{};
    List<Account> listOfAcc = new List<Account>();
    Set<String> setOfStrings = new Set<String>{};
    Map<String, Integer> mapOfStringAndInteger = new Map<String, Integer>();
    //new myRenamingClass(string oldName, string newName)
  }

  public static void apexSafeNavigationOperator() {
    String a = null;
    String b = 'abc';
    System.debug(a == null ? b : a);
    //comment First retrieve account or create new
    Account acc = new Account();
    acc.Name = 'test';
    insert acc;
    System.debug([SELECT Id, Name FROM Account WHERE Id = :acc.Id]?.Name);
  }

  public static void nestedMap() {
    /*
        Map<String, Map<String, List<String>>> mapOfCountriesWithStateAndDistricts = new Map<String, Map<String, List<String>>>();
        //  Country     States      Districts

        List<List<String>> countriesWithStateAndListOfDistrics = new List<List<String>>();
        countriesWithStateAndListOfDistrics.add(new List<String>{'India','West-Bengal','North 24 paraganas'});
        System.debug(countriesWithStateAndListOfDistrics);
        for(List<String> lst : countriesWithStateAndListOfDistrics){
            for(String ls: lst){
                System.debug(ls);
            }
        }
        //countries.add(new Countries('India','West-Bengal','North 24 paraganas'));*/

    Map<String, List<String>> mapOfDistrictWithList = new Map<String, List<String>>();
    mapOfDistrictWithList.put(
      'West-Bengal',
      new List<String>{ 'North-24 Parganas', 'Kolkata' }
    );
    mapOfDistrictWithList.put(
      'Barisal',
      new List<String>{ 'Barguna', 'Barisal' }
    );
    mapOfDistrictWithList.put(
      'San Fernando',
      new List<String>{ 'San Fernando' }
    );
    mapOfDistrictWithList.put('Andhra Pradesh', new List<String>{ 'Anantpur' });

    Map<String, List<String>> mapOfStatesWithCountry = new Map<String, List<String>>();
    mapOfStatesWithCountry.put(
      'India',
      new List<String>{ 'West-Bengal', 'Andhra Pradesh' }
    );
    mapOfStatesWithCountry.put('Bangladesh', new List<String>{ 'Barisal' });
    mapOfStatesWithCountry.put('Spain', new List<String>{ 'San Fernando' });

    Map<Integer, String> mapOfCountryWithCountryCode = new Map<Integer, String>();
    mapOfCountryWithCountryCode.put(+91, 'India');
    mapOfCountryWithCountryCode.put(+880, 'Bangladesh');
    mapOfCountryWithCountryCode.put(+34, 'Spain');

    Map<String, Map<String, List<String>>> mapOfCountriesWithStateAndDistricts = new Map<String, Map<String, List<String>>>();

    for (String key : mapOfStatesWithCountry.keyset()) {
      if (!mapOfCountriesWithStateAndDistricts.containsKey(key))
        mapOfCountriesWithStateAndDistricts.put(
          key,
          new Map<String, List<String>>()
        );

      if (mapOfCountriesWithStateAndDistricts.containsKey(key)) {
        for (String state : mapOfStatesWithCountry.get(key)) {
          mapOfCountriesWithStateAndDistricts.get(key)
            .put(state, new List<String>());

          if (mapOfCountriesWithStateAndDistricts.get(key).containsKey(state)) {
            mapOfCountriesWithStateAndDistricts.get(key)
              .get(state)
              .addAll(mapOfDistrictWithList.get(state));
          }
        }
      }
    }

    System.debug(mapOfCountriesWithStateAndDistricts);
  }
}

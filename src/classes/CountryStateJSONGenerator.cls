public class CountryStateJSONGenerator {
  public List<String> countryList { get; set; }

  public class States {
    public string stateName { get; set; }
    public List<Districts> districts { get; set; }
  }

  public class Districts {
    public string disctirctName { get; set; }
  }

  public class Country {
    public String countryName { get; set; }
    public Integer countryCode { get; set; }
    public Integer totalStatesNumber { get; set; }
    public Integer totalDistricts { get; set; }
    public List<States> states { get; set; }
  }

  public static CountryStateJSONGenerator parse(String json) {
    return (CountryStateJSONGenerator) System.JSON.deserialize(
      json,
      CountryStateJSONGenerator.class
    );
  }
}

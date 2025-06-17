{

  brave = {
    name = "Brave Search";
    urls = [{
      template = "https://search.brave.com/search";
      params = [
        { name = "q"; value = "{searchTerms}"; }
      ];
    }];
  };

}
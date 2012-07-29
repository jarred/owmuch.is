// Generated by CoffeeScript 1.3.3
(function() {
  var omi;

  omi = window.OwMuchIs || (window.OwMuchIs = {});

  omi.App = {
    init: function() {
      _.bindAll(this);
      $('form').bind('submit', this.submit);
      accounting.settings.currency.format = '<span class="currency-symbol">%s</span>%v';
    },
    setRates: function(rates) {
      this.rates = rates;
      if (window.location.search != null) {
        this.doConversion(String(window.location.search).replace(/\+/ig, ' ').replace(/\?q=/ig, '').replace(/\//ig, ''));
      }
    },
    submit: function(e) {
      e.preventDefault();
      this.doConversion($('input').val());
    },
    doConversion: function(term) {
      var amount, base, convertedAmount, currencyCodes, final, ratio;
      console.log('term', term);
      $('input[type=search]').val(term);
      amount = Number(term.match(/[0-9?.0-9]*/));
      currencyCodes = term.match(/[a-z]{3}/ig);
      base = currencyCodes[0].toUpperCase();
      final = geoplugin_currencyCode();
      if (currencyCodes[1] != null) {
        final = currencyCodes[1].toUpperCase();
      }
      ratio = this.rates.rates[final] * (1 / this.rates.rates[base]);
      convertedAmount = ratio * amount;
      console.log(this.rates);
      $('.amount.base').html("" + (accounting.formatMoney(amount, OwMuchIs.App.symbolFromCurrencyCode(base))) + "<span class=\"currency-code\">" + base + "</span>");
      $('.amount.conversion').html("" + (accounting.formatMoney(convertedAmount, OwMuchIs.App.symbolFromCurrencyCode(final))) + "<span class=\"currency-code\">" + final + "</span>");
    },
    symbolFromCurrencyCode: function(code) {
      switch (code) {
        case "JPY":
        case "CNY":
          return "&yen;";
        case "GBP":
          return "&pound;";
        case "EUR":
          return "&euro;";
        default:
          return "$";
      }
    }
  };

  omi.App.init();

}).call(this);

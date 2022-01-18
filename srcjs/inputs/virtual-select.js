import $ from "jquery";
import "shiny";
import "virtual-select-plugin/dist/virtual-select.min.css";
import "virtual-select-plugin/dist/virtual-select.min.js";


function transpose(data) {
  var res = [];
  var key, i;
  for (key in data) {
    for (i = 0; i < data[key].length; i++) {
      res[i] = res[i] || {};
      if (data[key][i] !== undefined) res[i][key] = data[key][i];
    }
  }
  return res;
}

var virtualSelectBinding = new Shiny.InputBinding();

$.extend(virtualSelectBinding, {
  find: (scope) => {
    return $(scope).find(".virtual-select");
  },
  getValue: (el) => {
    return el.value;
  },
  setValue: (el, value) => {
    el.setValue(value);
  },
  subscribe: (el, callback) => {
    $(el).on("change.virtualSelectBinding", function(e) {
      callback();
    });
  },
  unsubscribe: (el) => {
    $(el).off(".virtualSelectBinding");
  },
  receiveMessage: (el, data) => {

    if (data.hasOwnProperty("label")) {
      var label = document.getElementById(el.id + "-label");
      label.innerHTML = data.label;
    }

    if (data.hasOwnProperty("options")) {
      var options = data.options;
      var newOptions;
      if (options.type == "vector") {
        newOptions = options.choices.map((x) => {return {label: x, value: x};});
      } else if (options.type == "transpose") {
        newOptions = transpose(options.choices);
      } else if (options.type == "transpose_group") {
        var choices = options.choices;
        for (var i = 0; i < choices.length; i++) {
          choices[i].options = transpose(choices[i].options);
        }
        newOptions = choices;
      } else {
        newOptions = options.choices;
      }
      el.setOptions(newOptions);
    }

    if (data.hasOwnProperty("value")) {
      el.setValue(data.value);
    }

  },
  initialize: (el) => {
    var data = el.querySelector('script[data-for="' + el.id + '"]');
    data = JSON.parse(data.text);
    var config = data.config;
    var options = data.options;
    if (options.type == "vector") {
      config.options = options.choices.map((x) => {return {label: x, value: x};});
    } else if (options.type == "transpose") {
      config.options = transpose(options.choices);
    } else if (options.type == "transpose_group") {
      var choices = options.choices;
      for (var i = 0; i < choices.length; i++) {
        choices[i].options = transpose(choices[i].options);
      }
      config.options = choices;
    } else {
      config.options = options.choices;
    }
    config.ele = el;
    VirtualSelect.init(config);
  }
});

Shiny.inputBindings.register(virtualSelectBinding, "shinyvs.virtualSelectBinding");

import $ from "jquery";
import "shiny";
import "virtual-select-plugin/dist/virtual-select.min.css";
import "virtual-select-plugin/dist/virtual-select.min.js";


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
  initialize: (el) => {
    var config = el.querySelector('script[data-for="' + el.id + '"]');
    config = JSON.parse(config.text);
    console.log(config);
    if (Array.isArray(config.options) && typeof config.options[0] == "string") {
      config.options = config.options.map(function(x) {return {label: x, value: x};});
    }
    config.ele = el;
    VirtualSelect.init(config);
  }
});

Shiny.inputBindings.register(virtualSelectBinding, "shinyvs.virtualSelectBinding");

(function(namespace, $) {
  var Forms = namespace.Forms;

  Forms.MultivaloredInput = function(options) {
    var options = options || {};
    this.list = options.list;
    this.addBtn = options.addBtn;
    this.liTemplate = options.liTemplate;
    this.deleteTemplate = options.deleteTemplate;
    this.afterAdd = options.afterAdd;
  }

  Forms.MultivaloredInput.prototype.addItem = function(value) {
    var $list = $(this.list);
    var $deleteBtn = $(this.deleteTemplate).click(onDeleteItem);
    var $newLi = $(this.liTemplate).append($deleteBtn);
    $newLi.find("input").val(value);
    $list.append($newLi);
    if(this.afterAdd) {
      this.afterAdd($newLi);
    }
  }

  Forms.MultivaloredInput.prototype.replaceItems = function(values) {
    var component = this;
    $(this.list).empty();
    $.each(values, function() {
      component.addItem(this);
    });
  }

  Forms.MultivaloredInput.applyOn = function(options) {
    var options = options || {};
    options.liTemplate = $(options.templateScript).html().trim();
    options.deleteTemplate = "<button class='multivalored-input-delete-button'>Delete</button>";

    var component = new Forms.MultivaloredInput(options);

    $(options.addBtn).click(function(event) {
      event.preventDefault();
      component.addItem();
    });

    $(options.list).find("li:not(.undeletable)").append(options.deleteTemplate);
    $(".multivalored-input-delete-button").click(onDeleteItem);

    return component;
  };

  function onDeleteItem(event) {
    event.preventDefault();
    $(this).parent().remove();
  }
}(LNX_UTILS, jQuery));

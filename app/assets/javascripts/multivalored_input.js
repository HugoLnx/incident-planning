(function(namespace, $) {
  var Forms = namespace.Forms;

  Forms.MultivaloredInput = function(list, addBtn, liTemplate, deleteTemplate) {
    this.list = list;
    this.addBtn = addBtn;
    this.liTemplate = liTemplate;
    this.deleteTemplate = deleteTemplate;
  }

  Forms.MultivaloredInput.prototype.addItem = function(value) {
    var $list = $(this.list);
    var $deleteBtn = $(this.deleteTemplate).click(onDeleteItem);
    var $newLi = $(this.liTemplate).append($deleteBtn);
    $newLi.find("input").val(value);
    $list.append($newLi);
  }

  Forms.MultivaloredInput.prototype.replaceItems = function(values) {
    var component = this;
    $(this.list).empty();
    $.each(values, function() {
      component.addItem(this);
    });
  }

  Forms.MultivaloredInput.applyOn = function(list, addBtn, templateScript) {
    var $addBtn = $(addBtn);
    var liTemplate = $(templateScript).html().trim();
    var deleteTemplate = "<button class='multivalored-input-delete-button'>Delete</button>";

    var component = new Forms.MultivaloredInput(list, addBtn, liTemplate, deleteTemplate);

    $addBtn.click(function(event) {
      event.preventDefault();
      component.addItem();
    });

    $(list).find("li").append(deleteTemplate);
    $(".multivalored-input-delete-button").click(onDeleteItem);

    return component;
  };

  function onDeleteItem(event) {
    event.preventDefault();
    $(this).parent().remove();
  }
}(LNX_UTILS, jQuery));

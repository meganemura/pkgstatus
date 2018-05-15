(function() {
  const validatePackages = () => {
    let textareas = Array.from(document.querySelectorAll('.js-package-form'));

    if ( textareas.every(isTextareaEmpty) ) {
      alert('Require at least 1 package');
      return false;
    } else {
      return true;
    }
  };

  const isTextareaEmpty = (area) => {
    let text = area.value.trim();
    return text.length === 0;
  };

  window.validatePackages = validatePackages;
}());

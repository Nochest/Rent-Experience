window.onload = () => {
  setTimeout(() => {
    if (window.outerWidth < screen.width || window.outerHeight < screen.height) {
      window.moveTo(0, 0);
      window.resizeTo(screen.width, screen.height);
    }
  }, 100);
};

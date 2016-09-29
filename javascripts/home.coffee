---
---
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.webtoon-list--expandable li.is-more').click (e) ->
    $(this).removeClass('is-more')
    $(window).trigger('lazyduck')
    e.preventDefault()
    $(this).unbind('click')

  new Swiper('.swiper-container', {
    direction: 'horizontal',
    loop: true,
    autoHeight: true,
    autoplay: 5000,
    pagination: '.swiper-pagination',
    slidesPerView: 'auto',
    centeredSlides: true,
    nextButton: '.swiper-button-next',
    prevButton: '.swiper-button-prev',
  })

  $('.swiper-slide__title span, .swiper-slide__summary p').each ->
    $(this).adaptiveColor({wrap_el: '.swiper-slide'})

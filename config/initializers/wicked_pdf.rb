require "wicked_pdf"

WickedPdf.config.merge!(
  footer: {right: "Page [page] of [topage]"}
)

-- import colorizer plugin safely
local setup, colorizer = pcall(require, "colorizer")
if not setup then
	return
end

colorizer.setup({
	css = {
    css = true
  },
	scss = {
    css = true
  },
	"javascript",
	"html"
})

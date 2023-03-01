# potion-maker.nvim

Be an alchemist on vim.

## Intallation

### Using Lazy

```lua
'Matsa59/potion-maker.nvim'
```

### Using Packer

```lua
use { 'Matsa59/potion-maker.nvim' }
```

### Bindings

```vim
" Switch from your src file and test file (in both ways)
nmap <leader>mtt :PotionMakerToggleTestFile<CR>

" Execute the test where your cursor is
nmap <leader>mts :PotionMakerExecuteTestAtCursor<CR>

" Execute every tests of the file you're currently on
nmap <leader>mtS :PotionMakerExecuteTestForCurrentFile<CR>
```

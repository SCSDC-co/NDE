-- highlights-catppuccin-latte.lua
-- Custom highlight groups for Catppuccin Latte theme (Light)

local highlights = {
	NormalLineNr = { bg = "#eff1f5" },
	LineNr = { bg = "#eff1f5", fg = "#ccd0da" },
	CursorLineNr = { bg = "#eff1f5", fg = "#4c4f69", bold = true },
	SignColumn = { bg = "#eff1f5" },
	GitSignsAdd = { bg = "#eff1f5", fg = "#40a02b" },
	GitSignsChange = { bg = "#eff1f5", fg = "#df8e1d" },
	GitSignsDelete = { bg = "#eff1f5", fg = "#d20f39" },
	diffDeleted = { fg = "#d20f39" },
	DiagnosticSignError = { bg = "#eff1f5", fg = "#d20f39" },
	DiagnosticSignWarn = { bg = "#eff1f5", fg = "#df8e1d" },
	DiagnosticSignInfo = { bg = "#eff1f5", fg = "#209fb5" },
	DiagnosticSignHint = { bg = "#eff1f5", fg = "#ea76cb" },
	VertSplit = { fg = "#e6e9ef", bg = "#eff1f5" },
	WinSeparator = { fg = "#e6e9ef", bg = "#eff1f5" },
	BufferLineOffset = { bg = "#e6e9ef", fg = "#e6e9ef", bold = true },
	BufferLineOffsetSeparator = { bg = "#e6e9ef", fg = "#e6e9ef" },
	BufferLineFill = { bg = "#e6e9ef" },
	TerminalNormal = { bg = "#eff1f5" },
	TerminalBorder = { fg = "#eff1f5", bg = "#eff1f5" },
	Terminal = { bg = "#eff1f5" },
	WhichKey = { fg = "#7287fd", bg = "#eff1f5" },
	WhichKeyGroup = { fg = "#5c5f77", bg = "#eff1f5" },
	WhichKeyDesc = { fg = "#2a2e45", bg = "#eff1f5" },
	WhichKeyValue = { fg = "#2a2e45", bg = "#eff1f5" },
	WhichKeySeparator = { fg = "#5c5f77", bg = "#eff1f5" },
	WhichKeyFloat = { bg = "#eff1f5" },
	WhichKeyBorder = { fg = "#5c5f77", bg = "#eff1f5" },
	WhichKeyTitle = { fg = "#5c5f77", bg = "#eff1f5" },
	WhichKeyNormal = { bg = "#eff1f5" },
	CmpPmenu = { bg = "#eff1f5", fg = "#4c4f69" },
	CmpSel = { bg = "#ccd0da", fg = "#4c4f69" },
	CmpBorder = { fg = "#5c5f77", bg = "#eff1f5" },
	CmpDoc = { bg = "#eff1f5", fg = "#4c4f69" },
	CmpDocBorder = { fg = "#5c5f77", bg = "#eff1f5" },
	CmpItemKindText = { fg = "#4c4f69" },
	CmpItemKindMethod = { fg = "#7287fd" },
	CmpItemKindFunction = { fg = "#7287fd" },
	CmpItemKindConstructor = { fg = "#7287fd" },
	CmpItemKindField = { fg = "#1e66f5" },
	CmpItemKindVariable = { fg = "#4c4f69" },
	CmpItemKindClass = { fg = "#df8e1d" },
	CmpItemKindInterface = { fg = "#df8e1d" },
	CmpItemKindModule = { fg = "#df8e1d" },
	CmpItemKindProperty = { fg = "#1e66f5" },
	CmpItemKindUnit = { fg = "#e5a445" },
	CmpItemKindValue = { fg = "#e5a445" },
	CmpItemKindEnum = { fg = "#df8e1d" },
	CmpItemKindKeyword = { fg = "#ea76cb" },
	CmpItemKindSnippet = { fg = "#40a02b" },
	CmpItemKindColor = { fg = "#d20f39" },
	CmpItemKindFile = { fg = "#7287fd" },
	CmpItemKindReference = { fg = "#df8e1d" },
	CmpItemKindFolder = { fg = "#7287fd" },
	CmpItemKindEnumMember = { fg = "#e5a445" },
	CmpItemKindConstant = { fg = "#e5a445" },
	CmpItemKindStruct = { fg = "#df8e1d" },
	CmpItemKindEvent = { fg = "#df8e1d" },
	CmpItemKindOperator = { fg = "#ea76cb" },
	CmpItemKindTypeParameter = { fg = "#df8e1d" },
	CmpItemKindCodeium = { fg = "#7287fd" },
	CmpItemKindTextSel = { bg = "#4c4f69", fg = "#eff1f5", bold = true },
	CmpItemKindMethodSel = { bg = "#7287fd", fg = "#eff1f5", bold = true },
	CmpItemKindFunctionSel = { bg = "#7287fd", fg = "#eff1f5", bold = true },
	CmpItemKindConstructorSel = { bg = "#7287fd", fg = "#eff1f5", bold = true },
	CmpItemKindFieldSel = { bg = "#1e66f5", fg = "#eff1f5", bold = true },
	CmpItemKindVariableSel = { bg = "#4c4f69", fg = "#eff1f5", bold = true },
	CmpItemKindClassSel = { bg = "#df8e1d", fg = "#eff1f5", bold = true },
	CmpItemKindInterfaceSel = { bg = "#df8e1d", fg = "#eff1f5", bold = true },
	CmpItemKindModuleSel = { bg = "#df8e1d", fg = "#eff1f5", bold = true },
	CmpItemKindPropertySel = { bg = "#1e66f5", fg = "#eff1f5", bold = true },
	CmpItemKindUnitSel = { bg = "#e5a445", fg = "#eff1f5", bold = true },
	CmpItemKindValueSel = { bg = "#e5a445", fg = "#eff1f5", bold = true },
	CmpItemKindEnumSel = { bg = "#df8e1d", fg = "#eff1f5", bold = true },
	CmpItemKindKeywordSel = { bg = "#ea76cb", fg = "#eff1f5", bold = true },
	CmpItemKindSnippetSel = { bg = "#40a02b", fg = "#eff1f5", bold = true },
	CmpItemKindColorSel = { bg = "#d20f39", fg = "#eff1f5", bold = true },
	CmpItemKindFileSel = { bg = "#7287fd", fg = "#eff1f5", bold = true },
	CmpItemKindReferenceSel = { bg = "#df8e1d", fg = "#eff1f5", bold = true },
	CmpItemKindFolderSel = { bg = "#7287fd", fg = "#eff1f5", bold = true },
	CmpItemKindEnumMemberSel = { bg = "#e5a445", fg = "#eff1f5", bold = true },
	CmpItemKindConstantSel = { bg = "#e5a445", fg = "#eff1f5", bold = true },
	CmpItemKindStructSel = { bg = "#df8e1d", fg = "#eff1f5", bold = true },
	CmpItemKindEventSel = { bg = "#df8e1d", fg = "#eff1f5", bold = true },
	CmpItemKindOperatorSel = { bg = "#ea76cb", fg = "#eff1f5", bold = true },
	CmpItemKindTypeParameterSel = { bg = "#df8e1d", fg = "#eff1f5", bold = true },
	CmpItemKindCodeiumSel = { bg = "#7287fd", fg = "#eff1f5", bold = true },
	CmpScrollbar = { bg = "#e6e9ef" },
	CmpScrollbarThumb = { bg = "#7287fd" },
	PmenuSbar = { bg = "#e6e9ef" },
	PmenuThumb = { bg = "#7287fd" },
	HLIndent1 = { fg = "#ccd0da" },
	HLIndent2 = { fg = "#ccd0da" },
	HLIndent3 = { fg = "#ccd0da" },
	HLIndent4 = { fg = "#ccd0da" },
	HLIndent5 = { fg = "#ccd0da" },
	HLChunk1 = { fg = "#4c4f69" },
	HLChunk2 = { fg = "#4c4f69" },
	HLChunk3 = { fg = "#4c4f69" },
	HLChunk4 = { fg = "#4c4f69" },
	HLChunk5 = { fg = "#4c4f69" },
	InclineNormal = { bg = "#e6e9ef" },
	InclineNormalNC = { bg = "#e6e9ef" },
	MintyFloatBorder = { fg = "#5c5f77", bg = "#eff1f5" },
	MintyNormal = { bg = "#eff1f5" },
	NoiceCmdlinePopup = { bg = "#eff1f5", fg = "#4c4f69" },
	NoiceCmdlinePopupBorder = { bg = "#eff1f5", fg = "#5c5f77" },
	NoiceCmdlineIconCmdline = { bg = "#eff1f5", fg = "#5c5f77" },
	NoiceCmdlineIcon = { bg = "#eff1f5", fg = "#5c5f77" },
	NoiceCmdlinePopupTitle = { bg = "#eff1f5", fg = "#7287fd" },
	NoicePopup = { bg = "#eff1f5", fg = "#4c4f69" },
	NoicePopupBorder = { bg = "#eff1f5", fg = "#5c5f77" },
	NoiceConfirm = { bg = "#eff1f5", fg = "#4c4f69" },
	NoiceConfirmBorder = { bg = "#eff1f5", fg = "#5c5f77" },
	NoiceMini = { bg = "#eff1f5", fg = "#4c4f69" },
	NoiceFormatProgressDone = { bg = "#eff1f5", fg = "#40a02b" },
	NoiceFormatProgressTodo = { bg = "#eff1f5", fg = "#5c5f77" },
	NoiceFormatTitle = { bg = "#eff1f5", fg = "#7287fd" },
	NoiceFormatEvent = { bg = "#eff1f5", fg = "#1e66f5" },
	NoiceFormatKind = { bg = "#eff1f5", fg = "#df8e1d" },
	NoiceFormatDate = { bg = "#eff1f5", fg = "#ea76cb" },
	NoiceLspProgressTitle = { bg = "#eff1f5", fg = "#7287fd" },
	NoiceLspProgressClient = { bg = "#eff1f5", fg = "#1e66f5" },
	NoiceLspProgressSpinner = { bg = "#eff1f5", fg = "#df8e1d" },
	NoiceCmdlinePrompt = { bg = "#eff1f5", fg = "#7287fd" },
	MsgArea = { bg = "#eff1f5", fg = "#4c4f69" },
	MsgSeparator = { bg = "#eff1f5", fg = "#5c5f77" },
	NormalFloat = { bg = "#eff1f5", fg = "#4c4f69" },
	FloatBorder = { bg = "#eff1f5", fg = "#5c5f77" },
	Pmenu = { bg = "#eff1f5", fg = "#4c4f69" },
	PmenuSel = { bg = "#ccd0da", fg = "#4c4f69" },
	PmenuBorder = { bg = "#eff1f5", fg = "#5c5f77" },
	NeoTreeNormal = { bg = "#e6e9ef" },
	NeoTreeNormalNC = { bg = "#e6e9ef" },
	NeoTreeEndOfBuffer = { bg = "#e6e9ef", fg = "#e6e9ef" },
	NeoTreeWinSeparator = { fg = "#e6e9ef", bg = "#e6e9ef" },
	NeoTreeCursorLine = { bg = "#eff1f5" },
	ColorColumn = { bg = "#ccd0da" },
	VirtColumn = { fg = "#ccd0da" },
	FoldColumn = { bg = "#eff1f5", fg = "#ccd0da" },
}

return highlights

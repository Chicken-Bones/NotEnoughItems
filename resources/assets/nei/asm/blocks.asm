list spawnerPlaced
ILOAD 2
PUTSTATIC codechicken/nei/ItemMobSpawner.placedX:I
ILOAD 3
PUTSTATIC codechicken/nei/ItemMobSpawner.placedY:I
ILOAD 4
PUTSTATIC codechicken/nei/ItemMobSpawner.placedZ:I
RETURN

list d_spawnerWorld
ACONST_NULL

list spawnerWorld
ALOAD 0
INVOKEVIRTUAL net/minecraft/tileentity/MobSpawnerBaseLogic.getSpawnerWorld()Lnet/minecraft/world/World;

list n_commaFix
LDC *
INVOKEVIRTUAL java/lang/StringBuilder.append (Ljava/lang/String;)Ljava/lang/StringBuilder;
INVOKEVIRTUAL java/lang/StringBuilder.toString ()Ljava/lang/String;
ARETURN

list commaFix
INVOKESTATIC codechicken/nei/NEIServerUtils.fixTrailingCommaList(Ljava/lang/StringBuilder;)Ljava/lang/StringBuilder;

#begin GuiContainer patches

list m_getManager
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ARETURN

list m_setWorldAndResolution
ALOAD 0
ALOAD 1
ILOAD 2
ILOAD 3
INVOKESPECIAL net/minecraft/client/gui/GuiScreen.setWorldAndResolution (Lnet/minecraft/client/Minecraft;II)V
ALOAD 1
GETFIELD net/minecraft/client/Minecraft.currentScreen : Lnet/minecraft/client/gui/GuiScreen;
ALOAD 0
IF_ACMPNE LEND
ALOAD 0
NEW codechicken/nei/guihook/GuiContainerManager
DUP
ALOAD 0
INVOKESPECIAL codechicken/nei/guihook/GuiContainerManager.<init> (Lnet/minecraft/client/gui/inventory/GuiContainer;)V
PUTFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.load ()V
LEND
RETURN

list m_handleKeyboardInput
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.handleKeyboardInput ()V
RETURN

list m_handleMouseInput
ALOAD 0
INVOKESPECIAL net/minecraft/client/gui/GuiScreen.handleMouseInput ()V
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.handleMouseWheel ()V
RETURN

list m_publicKeyTyped
ALOAD 0
ILOAD 1
ILOAD 2
INVOKEVIRTUAL net/minecraft/client/gui/inventory/GuiContainer.func_73869_a(CI)V
RETURN

list m_callKeyTyped
ALOAD 0
ILOAD 1
ILOAD 2
INVOKEVIRTUAL net/minecraft/client/gui/inventory/GuiContainer.publicKeyTyped(CI)V
RETURN

list preDraw
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.preDraw ()V

list n_objectUnderMouse
INVOKEVIRTUAL net/minecraft/inventory/Slot.func_111238_b ()Z
IFEQ LSKIP

list objectUnderMouse
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ILOAD 1
ILOAD 2
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.objectUnderMouse (II)Z
IFNE LSKIP

list n_renderObjects
INVOKEVIRTUAL net/minecraft/client/gui/inventory/GuiContainer.func_146979_b (II)V
SIPUSH 2896
INVOKESTATIC org/lwjgl/opengl/GL11.glEnable (I)V

list renderObjects
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ILOAD 1
ILOAD 2
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.renderObjects (II)V

list d_renderToolTip
ALOAD 8
INVOKEVIRTUAL net/minecraft/entity/player/InventoryPlayer.func_70445_o ()Lnet/minecraft/item/ItemStack;
IFNONNULL LSKIP
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.field_147006_u : Lnet/minecraft/inventory/Slot;
IFNULL LSKIP
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.field_147006_u : Lnet/minecraft/inventory/Slot;
INVOKEVIRTUAL net/minecraft/inventory/Slot.func_75216_d ()Z
IFEQ LSKIP
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.field_147006_u : Lnet/minecraft/inventory/Slot;
INVOKEVIRTUAL net/minecraft/inventory/Slot.func_75211_c ()Lnet/minecraft/item/ItemStack;
ASTORE 10
ALOAD 0
ALOAD 10
ILOAD 1
ILOAD 2
INVOKEVIRTUAL net/minecraft/client/gui/inventory/GuiContainer.func_146285_a (Lnet/minecraft/item/ItemStack;II)V
LSKIP

list renderTooltips
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ILOAD 1
ILOAD 2
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.renderToolTips (II)V

list d_zLevel
LDC 200F

list zLevel
LDC 500F

list d_drawSlot
GETSTATIC net/minecraft/client/gui/inventory/GuiContainer.field_146296_j : Lnet/minecraft/client/renderer/entity/RenderItem;
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.field_146289_q : Lnet/minecraft/client/gui/FontRenderer;
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.field_146297_k : Lnet/minecraft/client/Minecraft;
INVOKEVIRTUAL net/minecraft/client/Minecraft.func_110434_K ()Lnet/minecraft/client/renderer/texture/TextureManager;
ALOAD 4
ILOAD 2
ILOAD 3
INVOKEVIRTUAL net/minecraft/client/renderer/entity/RenderItem.func_82406_b (Lnet/minecraft/client/gui/FontRenderer;Lnet/minecraft/client/renderer/texture/TextureManager;Lnet/minecraft/item/ItemStack;II)V
GETSTATIC net/minecraft/client/gui/inventory/GuiContainer.field_146296_j : Lnet/minecraft/client/renderer/entity/RenderItem;
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.field_146289_q : Lnet/minecraft/client/gui/FontRenderer;
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.field_146297_k : Lnet/minecraft/client/Minecraft;
INVOKEVIRTUAL net/minecraft/client/Minecraft.func_110434_K ()Lnet/minecraft/client/renderer/texture/TextureManager;
ALOAD 4
ILOAD 2
ILOAD 3
ALOAD 8
INVOKEVIRTUAL net/minecraft/client/renderer/entity/RenderItem.func_77021_b (Lnet/minecraft/client/gui/FontRenderer;Lnet/minecraft/client/renderer/texture/TextureManager;Lnet/minecraft/item/ItemStack;IILjava/lang/String;)V

list drawSlot
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ALOAD 1
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.renderSlotUnderlay (Lnet/minecraft/inventory/Slot;)V
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ALOAD 1
ALOAD 4
ILOAD 2
ILOAD 3
ALOAD 8
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.drawSlotItem (Lnet/minecraft/inventory/Slot;Lnet/minecraft/item/ItemStack;IILjava/lang/String;)V
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ALOAD 1
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.renderSlotOverlay (Lnet/minecraft/inventory/Slot;)V

list n_mouseClicked
INVOKESPECIAL net/minecraft/client/gui/GuiScreen.func_73864_a (III)V

list mouseClicked
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ILOAD 1
ILOAD 2
ILOAD 3
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.mouseClicked (III)Z
IFEQ LCONT
RETURN
LCONT

list d_handleMouseClick
ALOAD 0
ALOAD 5
ILOAD 11
ILOAD 3
ILOAD 13
INVOKEVIRTUAL net/minecraft/client/gui/inventory/GuiContainer.func_146984_a (Lnet/minecraft/inventory/Slot;III)V

list handleMouseClick
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ALOAD 5
ILOAD 11
ILOAD 3
ILOAD 13
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.handleMouseClick (Lnet/minecraft/inventory/Slot;III)V

list n_mouseDragged
ASTORE 7

list mouseDragged
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ILOAD 1
ILOAD 2
ILOAD 3
LLOAD 4
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.mouseDragged (IIIJ)V

list overrideMouseUp
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ILOAD 1
ILOAD 2
ILOAD 3
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.overrideMouseUp (III)Z
IFEQ LCONT
RETURN
LCONT

list d_handleMouseClick2
ALOAD 0
ALOAD 4
ILOAD 8
ILOAD 3
ILOAD 11
IFEQ L0
ICONST_1
GOTO LCONT
L0
ICONST_0
LCONT
INVOKEVIRTUAL net/minecraft/client/gui/inventory/GuiContainer.handleMouseClick (Lnet/minecraft/inventory/Slot;III)V

list handleMouseClick2
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ALOAD 4
ILOAD 8
ILOAD 3
ILOAD 11
IFEQ L0
ICONST_1
GOTO LCONT
L0
ICONST_0
LCONT
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.handleMouseClick (Lnet/minecraft/inventory/Slot;III)V

list n_mouseUpGoto
IFNULL LSTART
ILOAD 3
ALOAD 0

list n_mouseUp
LSKIP
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.field_146297_k : Lnet/minecraft/client/Minecraft;
GETFIELD net/minecraft/client/Minecraft.field_71439_g : Lnet/minecraft/client/entity/EntityClientPlayerMP;
GETFIELD net/minecraft/client/entity/EntityClientPlayerMP.field_71071_by : Lnet/minecraft/entity/player/InventoryPlayer;
INVOKEVIRTUAL net/minecraft/entity/player/InventoryPlayer.func_70445_o ()Lnet/minecraft/item/ItemStack;
IFNONNULL L30
ALOAD 0
LCONST_0
PUTFIELD net/minecraft/client/gui/inventory/GuiContainer.field_146997_J : J

list mouseUp
GOTO LSKIP
LSTART
ILOAD 3
IFLT LSKIP
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ILOAD 1
ILOAD 2
ILOAD 3
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.mouseUp (III)V

list d_handleSlotClick
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.field_146297_k : Lnet/minecraft/client/Minecraft;
GETFIELD net/minecraft/client/Minecraft.field_71442_b : Lnet/minecraft/client/multiplayer/PlayerControllerMP;
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.field_147002_h : Lnet/minecraft/inventory/Container;
GETFIELD net/minecraft/inventory/Container.field_75152_c : I
ILOAD 2
ILOAD 3
ILOAD 4
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.field_146297_k : Lnet/minecraft/client/Minecraft;
GETFIELD net/minecraft/client/Minecraft.field_71439_g : Lnet/minecraft/client/entity/EntityClientPlayerMP;
INVOKEVIRTUAL net/minecraft/client/multiplayer/PlayerControllerMP.func_78753_a (IIIILnet/minecraft/entity/player/EntityPlayer;)Lnet/minecraft/item/ItemStack;
POP

list handleSlotClick
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ILOAD 2
ILOAD 3
ILOAD 4
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.handleSlotClick (III)V

list lastKeyTyped
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ILOAD 2
ILOAD 1
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.lastKeyTyped (IC)Z
IFEQ LCONT
RETURN
LCONT

list n_updateScreen
ALOAD 0
INVOKESPECIAL net/minecraft/client/gui/GuiScreen.updateScreen ()V

list updateScreen
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.updateScreen ()V
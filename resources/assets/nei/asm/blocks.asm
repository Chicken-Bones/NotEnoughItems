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
INVOKEVIRTUAL net/minecraft/tileentity/MobSpawnerBaseLogic.func_98271_a()Lnet/minecraft/world/World;

list n_commaFix
LDC *
INVOKEVIRTUAL java/lang/StringBuilder.append (Ljava/lang/String;)Ljava/lang/StringBuilder;
INVOKEVIRTUAL java/lang/StringBuilder.toString ()Ljava/lang/String;
ARETURN

list commaFix
INVOKESTATIC codechicken/nei/NEIServerUtils.fixTrailingCommaList(Ljava/lang/StringBuilder;)Ljava/lang/StringBuilder;

list n_workbenchFix
ALOAD 0
ALOAD 5
BIPUSH 10
BIPUSH 46
ICONST_1
INVOKEVIRTUAL net/minecraft/inventory/ContainerWorkbench.func_75135_a (Lnet/minecraft/item/ItemStack;IIZ)Z

list workbenchFix
NEW codechicken/lib/inventory/InventoryRange
DUP
ALOAD 0
GETFIELD net/minecraft/inventory/ContainerWorkbench.field_75151_b : Ljava/util/List;
BIPUSH 10
INVOKEINTERFACE java/util/List.get (I)Ljava/lang/Object;
CHECKCAST net/minecraft/inventory/Slot
GETFIELD net/minecraft/inventory/Slot.field_75224_c : Lnet/minecraft/inventory/IInventory;
ICONST_0
BIPUSH 36
INVOKESPECIAL codechicken/lib/inventory/InventoryRange.<init>(Lnet/minecraft/inventory/IInventory;II)V
ALOAD 5
ICONST_1
INVOKESTATIC codechicken/lib/inventory/InventoryUtils.insertItem(Lcodechicken/lib/inventory/InventoryRange;Lnet/minecraft/item/ItemStack;Z)I
IFEQ LCONT
ACONST_NULL
ARETURN
LCONT

list d_glintAlphaFix
ICONST_2
IF_ICMPGE LBREAK
SIPUSH 772
ICONST_1
ICONST_0
ICONST_0
INVOKESTATIC net/minecraft/client/renderer/OpenGlHelper.func_148821_a (IIII)V

list glintAlphaFix
ICONST_1 #only do one loop. Normally the first one wipes the alpha, and the second one multiplies by the wiped alpha (0) and is redundant
IF_ICMPGE LBREAK
SIPUSH 772
ICONST_1
ICONST_0
ICONST_1 #keep the destination alpha
INVOKESTATIC net/minecraft/client/renderer/OpenGlHelper.func_148821_a (IIII)V


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
INVOKESPECIAL net/minecraft/client/gui/GuiScreen.func_146280_a (Lnet/minecraft/client/Minecraft;II)V
ALOAD 1
GETFIELD net/minecraft/client/Minecraft.field_71462_r : Lnet/minecraft/client/gui/GuiScreen;
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
INVOKESPECIAL net/minecraft/client/gui/GuiScreen.func_146274_d ()V
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.handleMouseWheel ()V
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
INVOKEVIRTUAL net/minecraft/client/renderer/entity/RenderItem.func_94148_a (Lnet/minecraft/client/gui/FontRenderer;Lnet/minecraft/client/renderer/texture/TextureManager;Lnet/minecraft/item/ItemStack;IILjava/lang/String;)V

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
INVOKEVIRTUAL net/minecraft/client/gui/inventory/GuiContainer.func_146984_a (Lnet/minecraft/inventory/Slot;III)V

list handleMouseClick
INVOKEVIRTUAL net/minecraft/client/gui/inventory/GuiContainer.managerHandleMouseClick (Lnet/minecraft/inventory/Slot;III)V

list m_managerHandleMouseClick
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ALOAD 1
ILOAD 2
ILOAD 3
ILOAD 4
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.handleMouseClick (Lnet/minecraft/inventory/Slot;III)V
RETURN

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
INVOKESPECIAL net/minecraft/client/gui/GuiScreen.func_73876_c ()V

list updateScreen
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.updateScreen ()V


#Other inventory modifications

list renderTabTooltip
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ILOAD 2
ILOAD 3
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.objectUnderMouse (II)Z
IFEQ LCONT
ICONST_0
IRETURN
LCONT

list handleTabClick
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
ILOAD 2
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.field_147003_i : I
IADD
ILOAD 3
ALOAD 0
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.field_147009_r : I
IADD
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.objectUnderMouse (II)Z
IFEQ LCONT
ICONST_0
IRETURN
LCONT

list beaconButtonObscured
ALOAD 0
# NEI will replace the owner with the appropriate inner class
GETFIELD net/minecraft/client/gui/inventory/GuiBeacon.this$0 : Lnet/minecraft/client/gui/inventory/GuiBeacon;
DUP
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.manager : Lcodechicken/nei/guihook/GuiContainerManager;
SWAP
DUP
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.field_147003_i : I
ILOAD 1
IADD
SWAP
GETFIELD net/minecraft/client/gui/inventory/GuiContainer.field_147009_r : I
ILOAD 2
IADD
INVOKEVIRTUAL codechicken/nei/guihook/GuiContainerManager.objectUnderMouse (II)Z
IFEQ LCONT
RETURN
LCONT


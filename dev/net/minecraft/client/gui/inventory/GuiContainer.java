package net.minecraft.client.gui.inventory;

import codechicken.nei.guihook.GuiContainerManager;

import com.google.common.collect.Sets;
import java.io.IOException;
import java.util.Iterator;
import java.util.Set;
import net.minecraft.client.Minecraft;
import net.minecraft.client.gui.FontRenderer;
import net.minecraft.client.gui.GuiScreen;
import net.minecraft.client.renderer.GlStateManager;
import net.minecraft.client.renderer.OpenGlHelper;
import net.minecraft.client.renderer.RenderHelper;
import net.minecraft.client.renderer.texture.TextureAtlasSprite;
import net.minecraft.client.renderer.texture.TextureMap;
import net.minecraft.entity.player.InventoryPlayer;
import net.minecraft.inventory.Container;
import net.minecraft.inventory.Slot;
import net.minecraft.item.ItemStack;
import net.minecraft.util.EnumChatFormatting;
import net.minecraft.util.MathHelper;
import net.minecraft.util.ResourceLocation;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;
import org.lwjgl.input.Keyboard;

@SideOnly(Side.CLIENT)
public abstract class GuiContainer extends GuiScreen
{
    protected static final ResourceLocation inventoryBackground = new ResourceLocation("textures/gui/container/inventory.png");
    public int xSize = 176;
    public int ySize = 166;
    public Container inventorySlots;
    public int guiLeft;
    public int guiTop;
    private Slot theSlot;
    private Slot clickedSlot;
    private boolean isRightMouseClick;
    private ItemStack draggedStack;
    private int touchUpX;
    private int touchUpY;
    private Slot returningStackDestSlot;
    private long returningStackTime;
    private ItemStack returningStack;
    private Slot currentDragTargetSlot;
    private long dragItemDropDelay;
    public final Set dragSplittingSlots = Sets.newHashSet();
    public boolean dragSplitting;
    private int dragSplittingLimit;
    private int dragSplittingButton;
    private boolean ignoreMouseUp;
    private int dragSplittingRemnant;
    private long lastClickTime;
    private Slot lastClickSlot;
    private int lastClickButton;
    private boolean doubleClick;
    private ItemStack shiftClickedSlot;
    private static final String __OBFID = "CL_00000737";

    public GuiContainerManager manager;

    public GuiContainer(Container p_i1072_1_)
    {
        this.inventorySlots = p_i1072_1_;
        this.ignoreMouseUp = true;
    }

    public void initGui()
    {
        super.initGui();
        this.mc.thePlayer.openContainer = this.inventorySlots;
        this.guiLeft = (this.width - this.xSize) / 2;
        this.guiTop = (this.height - this.ySize) / 2;
    }

    public void drawScreen(int mouseX, int mouseY, float partialTicks)
    {
        manager.preDraw();
        
        this.drawDefaultBackground();
        int k = this.guiLeft;
        int l = this.guiTop;
        this.drawGuiContainerBackgroundLayer(partialTicks, mouseX, mouseY);
        GlStateManager.disableRescaleNormal();
        RenderHelper.disableStandardItemLighting();
        GlStateManager.disableLighting();
        GlStateManager.disableDepth();
        super.drawScreen(mouseX, mouseY, partialTicks);
        RenderHelper.enableGUIStandardItemLighting();
        GlStateManager.pushMatrix();
        GlStateManager.translate((float)k, (float)l, 0.0F);
        GlStateManager.color(1.0F, 1.0F, 1.0F, 1.0F);
        GlStateManager.enableRescaleNormal();
        this.theSlot = null;
        short short1 = 240;
        short short2 = 240;
        OpenGlHelper.setLightmapTextureCoords(OpenGlHelper.lightmapTexUnit, (float)short1 / 1.0F, (float)short2 / 1.0F);
        GlStateManager.color(1.0F, 1.0F, 1.0F, 1.0F);
        int k1;

        for (int i1 = 0; i1 < this.inventorySlots.inventorySlots.size(); ++i1)
        {
            Slot slot = (Slot)this.inventorySlots.inventorySlots.get(i1);
            this.drawSlot(slot);

            if (this.isMouseOverSlot(slot, mouseX, mouseY) && slot.canBeHovered() && !manager.objectUnderMouse(mouseX, mouseY))
            {
                this.theSlot = slot;
                GlStateManager.disableLighting();
                GlStateManager.disableDepth();
                int j1 = slot.xDisplayPosition;
                k1 = slot.yDisplayPosition;
                GlStateManager.colorMask(true, true, true, false);
                this.drawGradientRect(j1, k1, j1 + 16, k1 + 16, -2130706433, -2130706433);
                GlStateManager.colorMask(true, true, true, true);
                GlStateManager.enableLighting();
                GlStateManager.enableDepth();
            }
        }

        RenderHelper.disableStandardItemLighting();
        this.drawGuiContainerForegroundLayer(mouseX, mouseY);
        RenderHelper.enableGUIStandardItemLighting();
        
        manager.renderObjects(mouseX, mouseY);

        InventoryPlayer inventoryplayer = this.mc.thePlayer.inventory;
        ItemStack itemstack = this.draggedStack == null ? inventoryplayer.getItemStack() : this.draggedStack;

        if (itemstack != null)
        {
            byte b0 = 8;
            k1 = this.draggedStack == null ? 8 : 16;
            String s = null;

            if (this.draggedStack != null && this.isRightMouseClick)
            {
                itemstack = itemstack.copy();
                itemstack.stackSize = MathHelper.ceiling_float_int((float)itemstack.stackSize / 2.0F);
            }
            else if (this.dragSplitting && this.dragSplittingSlots.size() > 1)
            {
                itemstack = itemstack.copy();
                itemstack.stackSize = this.dragSplittingRemnant;

                if (itemstack.stackSize == 0)
                {
                    s = "" + EnumChatFormatting.YELLOW + "0";
                }
            }

            this.drawItemStack(itemstack, mouseX - k - b0, mouseY - l - k1, s);
        }

        if (this.returningStack != null)
        {
            float f1 = (float)(Minecraft.getSystemTime() - this.returningStackTime) / 100.0F;

            if (f1 >= 1.0F)
            {
                f1 = 1.0F;
                this.returningStack = null;
            }

            k1 = this.returningStackDestSlot.xDisplayPosition - this.touchUpX;
            int j2 = this.returningStackDestSlot.yDisplayPosition - this.touchUpY;
            int l1 = this.touchUpX + (int)((float)k1 * f1);
            int i2 = this.touchUpY + (int)((float)j2 * f1);
            this.drawItemStack(this.returningStack, l1, i2, (String)null);
        }

        GlStateManager.popMatrix();
        /*
        if (inventoryplayer.getItemStack() == null && this.theSlot != null && this.theSlot.getHasStack())
        {
            ItemStack itemstack1 = this.theSlot.getStack();
            this.renderToolTip(itemstack1, mouseX, mouseY);
        }
        */
        manager.renderToolTips(mouseX, mouseY);

        GlStateManager.enableLighting();
        GlStateManager.enableDepth();
        RenderHelper.enableStandardItemLighting();
    }

    private void drawItemStack(ItemStack stack, int x, int y, String altText)
    {
        GlStateManager.translate(0.0F, 0.0F, 32.0F);
        this.zLevel = 500.0F;
        itemRender.zLevel = 500.0F;
        FontRenderer font = null;
        if (stack != null) font = stack.getItem().getFontRenderer(stack);
        if (font == null) font = fontRendererObj;
        this.itemRender.renderItemAndEffectIntoGUI(stack, x, y);
        this.itemRender.renderItemOverlayIntoGUI(font, stack, x, y - (this.draggedStack == null ? 0 : 8), altText);
        this.zLevel = 0.0F;
        this.itemRender.zLevel = 0.0F;
    }

    protected void drawGuiContainerForegroundLayer(int mouseX, int mouseY) {}

    protected abstract void drawGuiContainerBackgroundLayer(float partialTicks, int mouseX, int mouseY);

    private void drawSlot(Slot slotIn)
    {
        int i = slotIn.xDisplayPosition;
        int j = slotIn.yDisplayPosition;
        ItemStack itemstack = slotIn.getStack();
        boolean flag = false;
        boolean flag1 = slotIn == this.clickedSlot && this.draggedStack != null && !this.isRightMouseClick;
        ItemStack itemstack1 = this.mc.thePlayer.inventory.getItemStack();
        String s = null;

        if (slotIn == this.clickedSlot && this.draggedStack != null && this.isRightMouseClick && itemstack != null)
        {
            itemstack = itemstack.copy();
            itemstack.stackSize /= 2;
        }
        else if (this.dragSplitting && this.dragSplittingSlots.contains(slotIn) && itemstack1 != null)
        {
            if (this.dragSplittingSlots.size() == 1)
            {
                return;
            }

            if (Container.canAddItemToSlot(slotIn, itemstack1, true) && this.inventorySlots.canDragIntoSlot(slotIn))
            {
                itemstack = itemstack1.copy();
                flag = true;
                Container.computeStackSize(this.dragSplittingSlots, this.dragSplittingLimit, itemstack, slotIn.getStack() == null ? 0 : slotIn.getStack().stackSize);

                if (itemstack.stackSize > itemstack.getMaxStackSize())
                {
                    s = EnumChatFormatting.YELLOW + "" + itemstack.getMaxStackSize();
                    itemstack.stackSize = itemstack.getMaxStackSize();
                }

                if (itemstack.stackSize > slotIn.getItemStackLimit(itemstack))
                {
                    s = EnumChatFormatting.YELLOW + "" + slotIn.getItemStackLimit(itemstack);
                    itemstack.stackSize = slotIn.getItemStackLimit(itemstack);
                }
            }
            else
            {
                this.dragSplittingSlots.remove(slotIn);
                this.updateDragSplitting();
            }
        }

        this.zLevel = 100.0F;
        this.itemRender.zLevel = 100.0F;

        if (itemstack == null)
        {
            TextureAtlasSprite textureatlassprite = slotIn.getBackgroundSprite();

            if (textureatlassprite != null)
            {
                GlStateManager.disableLighting();
                this.mc.getTextureManager().bindTexture(slotIn.getBackgroundLocation());
                this.drawTexturedModalRect(i, j, textureatlassprite, 16, 16);
                GlStateManager.enableLighting();
                flag1 = true;
            }
        }

        if (!flag1)
        {
            if (flag)
            {
                drawRect(i, j, i + 16, j + 16, -2130706433);
            }

            GlStateManager.enableDepth();
            manager.renderSlotUnderlay(slotIn);
            manager.drawSlotItem(slotIn, itemstack, i, j, s);
            manager.renderSlotOverlay(slotIn);
        }

        this.itemRender.zLevel = 0.0F;
        this.zLevel = 0.0F;
    }

    private void updateDragSplitting()
    {
        ItemStack itemstack = this.mc.thePlayer.inventory.getItemStack();

        if (itemstack != null && this.dragSplitting)
        {
            this.dragSplittingRemnant = itemstack.stackSize;
            ItemStack itemstack1;
            int i;

            for (Iterator iterator = this.dragSplittingSlots.iterator(); iterator.hasNext(); this.dragSplittingRemnant -= itemstack1.stackSize - i)
            {
                Slot slot = (Slot)iterator.next();
                itemstack1 = itemstack.copy();
                i = slot.getStack() == null ? 0 : slot.getStack().stackSize;
                Container.computeStackSize(this.dragSplittingSlots, this.dragSplittingLimit, itemstack1, i);

                if (itemstack1.stackSize > itemstack1.getMaxStackSize())
                {
                    itemstack1.stackSize = itemstack1.getMaxStackSize();
                }

                if (itemstack1.stackSize > slot.getItemStackLimit(itemstack1))
                {
                    itemstack1.stackSize = slot.getItemStackLimit(itemstack1);
                }
            }
        }
    }

    public Slot getSlotAtPosition(int x, int y)
    {
        for (int k = 0; k < this.inventorySlots.inventorySlots.size(); ++k)
        {
            Slot slot = (Slot)this.inventorySlots.inventorySlots.get(k);

            if (this.isMouseOverSlot(slot, x, y))
            {
                return slot;
            }
        }

        return null;
    }

    protected void mouseClicked(int mouseX, int mouseY, int mouseButton) throws IOException
    {
        if (manager.mouseClicked(mouseX, mouseY, mouseButton))
            return;

        super.mouseClicked(mouseX, mouseY, mouseButton);
        boolean flag = mouseButton == this.mc.gameSettings.keyBindPickBlock.getKeyCode() + 100;
        Slot slot = this.getSlotAtPosition(mouseX, mouseY);
        long l = Minecraft.getSystemTime();
        this.doubleClick = this.lastClickSlot == slot && l - this.lastClickTime < 250L && this.lastClickButton == mouseButton;
        this.ignoreMouseUp = false;

        if (mouseButton == 0 || mouseButton == 1 || flag)
        {
            int i1 = this.guiLeft;
            int j1 = this.guiTop;
            boolean flag1 = mouseX < i1 || mouseY < j1 || mouseX >= i1 + this.xSize || mouseY >= j1 + this.ySize;
            int k1 = -1;

            if (slot != null)
            {
                k1 = slot.slotNumber;
            }

            if (flag1)
            {
                k1 = -999;
            }

            if (this.mc.gameSettings.touchscreen && flag1 && this.mc.thePlayer.inventory.getItemStack() == null)
            {
                this.mc.displayGuiScreen((GuiScreen)null);
                return;
            }

            if (k1 != -1)
            {
                if (this.mc.gameSettings.touchscreen)
                {
                    if (slot != null && slot.getHasStack())
                    {
                        this.clickedSlot = slot;
                        this.draggedStack = null;
                        this.isRightMouseClick = mouseButton == 1;
                    }
                    else
                    {
                        this.clickedSlot = null;
                    }
                }
                else if (!this.dragSplitting)
                {
                    if (this.mc.thePlayer.inventory.getItemStack() == null)
                    {
                        if (mouseButton == this.mc.gameSettings.keyBindPickBlock.getKeyCode() + 100)
                        {
                            managerHandleMouseClick(slot, k1, mouseButton, 3);
                        }
                        else
                        {
                            boolean flag2 = k1 != -999 && (Keyboard.isKeyDown(42) || Keyboard.isKeyDown(54));
                            byte b0 = 0;

                            if (flag2)
                            {
                                this.shiftClickedSlot = slot != null && slot.getHasStack() ? slot.getStack() : null;
                                b0 = 1;
                            }
                            else if (k1 == -999)
                            {
                                b0 = 4;
                            }

                            managerHandleMouseClick(slot, k1, mouseButton, b0);
                        }

                        this.ignoreMouseUp = true;
                    }
                    else
                    {
                        this.dragSplitting = true;
                        this.dragSplittingButton = mouseButton;
                        this.dragSplittingSlots.clear();

                        if (mouseButton == 0)
                        {
                            this.dragSplittingLimit = 0;
                        }
                        else if (mouseButton == 1)
                        {
                            this.dragSplittingLimit = 1;
                        }
                        else if (mouseButton == this.mc.gameSettings.keyBindPickBlock.getKeyCode() + 100)
                        {
                            this.dragSplittingLimit = 2;
                        }
                    }
                }
            }
        }

        this.lastClickSlot = slot;
        this.lastClickTime = l;
        this.lastClickButton = mouseButton;
    }

    protected void mouseClickMove(int mouseX, int mouseY, int clickedMouseButton, long timeSinceLastClick)
    {
        Slot slot = this.getSlotAtPosition(mouseX, mouseY);
        ItemStack itemstack = this.mc.thePlayer.inventory.getItemStack();
        
        manager.mouseDragged(mouseX, mouseY, clickedMouseButton, timeSinceLastClick);

        if (this.clickedSlot != null && this.mc.gameSettings.touchscreen)
        {
            if (clickedMouseButton == 0 || clickedMouseButton == 1)
            {
                if (this.draggedStack == null)
                {
                    if (slot != this.clickedSlot)
                    {
                        this.draggedStack = this.clickedSlot.getStack().copy();
                    }
                }
                else if (this.draggedStack.stackSize > 1 && slot != null && Container.canAddItemToSlot(slot, this.draggedStack, false))
                {
                    long i1 = Minecraft.getSystemTime();

                    if (this.currentDragTargetSlot == slot)
                    {
                        if (i1 - this.dragItemDropDelay > 500L)
                        {
                            managerHandleMouseClick(this.clickedSlot, this.clickedSlot.slotNumber, 0, 0);
                            managerHandleMouseClick(slot, slot.slotNumber, 1, 0);
                            managerHandleMouseClick(this.clickedSlot, this.clickedSlot.slotNumber, 0, 0);
                            this.dragItemDropDelay = i1 + 750L;
                            --this.draggedStack.stackSize;
                        }
                    }
                    else
                    {
                        this.currentDragTargetSlot = slot;
                        this.dragItemDropDelay = i1;
                    }
                }
            }
        }
        else if (this.dragSplitting && slot != null && itemstack != null && itemstack.stackSize > this.dragSplittingSlots.size() && Container.canAddItemToSlot(slot, itemstack, true) && slot.isItemValid(itemstack) && this.inventorySlots.canDragIntoSlot(slot))
        {
            this.dragSplittingSlots.add(slot);
            this.updateDragSplitting();
        }
    }

    protected void mouseReleased(int mouseX, int mouseY, int state)
    {
        super.mouseReleased(mouseX, mouseY, state); //Forge, Call parent to release buttons

        if(manager.overrideMouseUp(mouseX, mouseY, state))
            return;

        Slot slot = this.getSlotAtPosition(mouseX, mouseY);
        int l = this.guiLeft;
        int i1 = this.guiTop;
        boolean flag = mouseX < l || mouseY < i1 || mouseX >= l + this.xSize || mouseY >= i1 + this.ySize;
        int j1 = -1;

        if (slot != null)
        {
            j1 = slot.slotNumber;
        }

        if (flag)
        {
            j1 = -999;
        }

        Slot slot1;
        Iterator iterator;

        if (this.doubleClick && slot != null && state == 0 && this.inventorySlots.canMergeSlot((ItemStack)null, slot))
        {
            if (isShiftKeyDown())
            {
                if (slot != null && slot.inventory != null && this.shiftClickedSlot != null)
                {
                    iterator = this.inventorySlots.inventorySlots.iterator();

                    while (iterator.hasNext())
                    {
                        slot1 = (Slot)iterator.next();

                        if (slot1 != null && slot1.canTakeStack(this.mc.thePlayer) && slot1.getHasStack() && slot1.inventory == slot.inventory && Container.canAddItemToSlot(slot1, this.shiftClickedSlot, true))
                        {
                            managerHandleMouseClick(slot1, slot1.slotNumber, state, 1);
                        }
                    }
                }
            }
            else
            {
                managerHandleMouseClick(slot, j1, state, 6);
            }

            this.doubleClick = false;
            this.lastClickTime = 0L;
        }
        else
        {
            if (this.dragSplitting && this.dragSplittingButton != state)
            {
                this.dragSplitting = false;
                this.dragSplittingSlots.clear();
                this.ignoreMouseUp = true;
                return;
            }

            if (this.ignoreMouseUp)
            {
                this.ignoreMouseUp = false;
                return;
            }

            boolean flag1;

            if (this.clickedSlot != null && this.mc.gameSettings.touchscreen)
            {
                if (state == 0 || state == 1)
                {
                    if (this.draggedStack == null && slot != this.clickedSlot)
                    {
                        this.draggedStack = this.clickedSlot.getStack();
                    }

                    flag1 = Container.canAddItemToSlot(slot, this.draggedStack, false);

                    if (j1 != -1 && this.draggedStack != null && flag1)
                    {
                        managerHandleMouseClick(this.clickedSlot, this.clickedSlot.slotNumber, state, 0);
                        managerHandleMouseClick(slot, j1, 0, 0);

                        if (this.mc.thePlayer.inventory.getItemStack() != null)
                        {
                            managerHandleMouseClick(this.clickedSlot, this.clickedSlot.slotNumber, state, 0);
                            this.touchUpX = mouseX - l;
                            this.touchUpY = mouseY - i1;
                            this.returningStackDestSlot = this.clickedSlot;
                            this.returningStack = this.draggedStack;
                            this.returningStackTime = Minecraft.getSystemTime();
                        }
                        else
                        {
                            this.returningStack = null;
                        }
                    }
                    else if (this.draggedStack != null)
                    {
                        this.touchUpX = mouseX - l;
                        this.touchUpY = mouseY - i1;
                        this.returningStackDestSlot = this.clickedSlot;
                        this.returningStack = this.draggedStack;
                        this.returningStackTime = Minecraft.getSystemTime();
                    }

                    this.draggedStack = null;
                    this.clickedSlot = null;
                }
            }
            else if (this.dragSplitting && !this.dragSplittingSlots.isEmpty())
            {
                managerHandleMouseClick((Slot)null, -999, Container.func_94534_d(0, this.dragSplittingLimit), 5);
                iterator = this.dragSplittingSlots.iterator();

                while (iterator.hasNext())
                {
                    slot1 = (Slot)iterator.next();
                    managerHandleMouseClick(slot1, slot1.slotNumber, Container.func_94534_d(1, this.dragSplittingLimit), 5);
                }

                managerHandleMouseClick((Slot)null, -999, Container.func_94534_d(2, this.dragSplittingLimit), 5);
            }
            else if (this.mc.thePlayer.inventory.getItemStack() != null)
            {
                if (state == this.mc.gameSettings.keyBindPickBlock.getKeyCode() + 100)
                {
                    managerHandleMouseClick(slot, j1, state, 3);
                }
                else
                {
                    flag1 = j1 != -999 && (Keyboard.isKeyDown(42) || Keyboard.isKeyDown(54));

                    if (flag1)
                    {
                        this.shiftClickedSlot = slot != null && slot.getHasStack() ? slot.getStack() : null;
                    }

                    managerHandleMouseClick(slot, j1, state, flag1 ? 1 : 0);
                }
            }
            else if(state >= 0)
                manager.mouseUp(mouseX, mouseY, state);
        }

        if (this.mc.thePlayer.inventory.getItemStack() == null)
        {
            this.lastClickTime = 0L;
        }

        this.dragSplitting = false;
    }

    private boolean isMouseOverSlot(Slot slotIn, int mouseX, int mouseY)
    {
        return this.isPointInRegion(slotIn.xDisplayPosition, slotIn.yDisplayPosition, 16, 16, mouseX, mouseY);
    }

    protected boolean isPointInRegion(int left, int top, int right, int bottom, int pointX, int pointY)
    {
        int k1 = this.guiLeft;
        int l1 = this.guiTop;
        pointX -= k1;
        pointY -= l1;
        return pointX >= left - 1 && pointX < left + right + 1 && pointY >= top - 1 && pointY < top + bottom + 1;
    }

    protected void handleMouseClick(Slot slotIn, int slotId, int clickedButton, int clickType)
    {
        if (slotIn != null)
        {
            slotId = slotIn.slotNumber;
        }

        manager.handleSlotClick(slotId, clickedButton, clickType);
    }

    protected void keyTyped(char typedChar, int keyCode) throws IOException
    {
        if(manager.lastKeyTyped(keyCode, typedChar))
            return;

        if (keyCode == 1 || keyCode == this.mc.gameSettings.keyBindInventory.getKeyCode())
        {
            this.mc.thePlayer.closeScreen();
        }

        this.checkHotbarKeys(keyCode);

        if (this.theSlot != null && this.theSlot.getHasStack())
        {
            if (keyCode == this.mc.gameSettings.keyBindPickBlock.getKeyCode())
            {
                managerHandleMouseClick(this.theSlot, this.theSlot.slotNumber, 0, 3);
            }
            else if (keyCode == this.mc.gameSettings.keyBindDrop.getKeyCode())
            {
                managerHandleMouseClick(this.theSlot, this.theSlot.slotNumber, isCtrlKeyDown() ? 1 : 0, 4);
            }
        }
    }

    protected boolean checkHotbarKeys(int keyCode)
    {
        if (this.mc.thePlayer.inventory.getItemStack() == null && this.theSlot != null)
        {
            for (int j = 0; j < 9; ++j)
            {
                if (keyCode == this.mc.gameSettings.keyBindsHotbar[j].getKeyCode())
                {
                    managerHandleMouseClick(this.theSlot, this.theSlot.slotNumber, j, 2);
                    return true;
                }
            }
        }

        return false;
    }

    public void onGuiClosed()
    {
        if (this.mc.thePlayer != null)
        {
            this.inventorySlots.onContainerClosed(this.mc.thePlayer);
        }
    }

    public boolean doesGuiPauseGame()
    {
        return false;
    }

    public void updateScreen()
    {
        super.updateScreen();
        manager.updateScreen();

        if (!this.mc.thePlayer.isEntityAlive() || this.mc.thePlayer.isDead)
        {
            this.mc.thePlayer.closeScreen();
        }
    }
    
    public void setWorldAndResolution(Minecraft mc, int i, int j)
    {
        super.setWorldAndResolution(mc, i, j);
        if(mc.currentScreen == this)
        {
            manager = new GuiContainerManager(this);
            manager.load();
        }
    }
    
    public void handleKeyboardInput()
    {
        manager.handleKeyboardInput();
    }
    
    public void handleMouseInput()
    {
        super.handleMouseInput();
        manager.handleMouseWheel();
    }

	public void managerHandleMouseClick(Slot slot, int slotIndex, int button, int modifiers)
    {
        manager.handleMouseClick(slot, slotIndex, button, modifiers);
    }
}
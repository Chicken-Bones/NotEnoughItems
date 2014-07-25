package codechicken.nei.config;

import codechicken.core.gui.GuiCCButton;
import codechicken.lib.render.CCRenderState;
import org.lwjgl.opengl.GL11;

public class PatreonButton extends GuiCCButton
{
    public PatreonButton(int x, int y, int width, int height) {
        super(x, y, width, height, null);
    }

    @Override
    public void drawButtonTex(int mousex, int mousey) {
        super.drawButtonTex(mousex, mousey);

        GL11.glColor4f(1, 1, 1, 1);
        CCRenderState.changeTexture("nei:textures/patreonNeon.png");
        int texh = height-4;
        int texw = texh*4;
        func_146110_a(x+width/2-texw/2, y+height/2-texh/2, 0, 0, texw, texh, texw, texh);
    }
}

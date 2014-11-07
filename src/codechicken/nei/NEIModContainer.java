package codechicken.nei;

import codechicken.core.CommonUtils;
import codechicken.core.launch.CodeChickenCorePlugin;
import codechicken.nei.api.IConfigureNEI;
import codechicken.nei.asm.NEICorePlugin;
import com.google.common.eventbus.EventBus;
import com.google.common.eventbus.Subscribe;
import cpw.mods.fml.client.FMLFileResourcePack;
import cpw.mods.fml.client.FMLFolderResourcePack;
import cpw.mods.fml.common.DummyModContainer;
import cpw.mods.fml.common.LoadController;
import cpw.mods.fml.common.MetadataCollection;
import cpw.mods.fml.common.ModMetadata;
import cpw.mods.fml.common.event.FMLInitializationEvent;
import cpw.mods.fml.common.event.FMLPreInitializationEvent;
import cpw.mods.fml.common.versioning.ArtifactVersion;
import cpw.mods.fml.common.versioning.VersionParser;
import cpw.mods.fml.common.versioning.VersionRange;
import net.minecraft.util.EnumChatFormatting;

import java.io.File;
import java.util.*;

public class NEIModContainer extends DummyModContainer
{
    public static LinkedList<IConfigureNEI> plugins = new LinkedList<IConfigureNEI>();

    public NEIModContainer() {
        super(MetadataCollection.from(MetadataCollection.class.getResourceAsStream("/neimod.info"), "NotEnoughItems").getMetadataForId("NotEnoughItems", null));
        loadMetadata();
    }

    @Override
    public Set<ArtifactVersion> getRequirements() {
        Set<ArtifactVersion> deps = new HashSet<ArtifactVersion>();
        deps.add(VersionParser.parseVersionReference("CodeChickenCore@["+CodeChickenCorePlugin.version+",)"));
        return deps;
    }

    @Override
    public List<ArtifactVersion> getDependencies() {
        return new LinkedList<ArtifactVersion>(getRequirements());
    }

    private String description;
    private void loadMetadata() {
        description = super.getMetadata().description.replace("Supporters:", EnumChatFormatting.AQUA+"Supporters:");
    }

    @Override
    public ModMetadata getMetadata() {
        String s_plugins = "";
        if (plugins.size() == 0) {
            s_plugins += EnumChatFormatting.RED+"No installed plugins.";
        } else {
            s_plugins += EnumChatFormatting.GREEN+"Installed plugins: ";
            for (int i = 0; i < plugins.size(); i++) {
                if (i > 0)
                    s_plugins += ", ";
                IConfigureNEI plugin = plugins.get(i);
                s_plugins += plugin.getName() + " " + plugin.getVersion();
            }
            s_plugins += ".";
        }

        ModMetadata meta = super.getMetadata();
        meta.description = description.replace("<plugins>", s_plugins);
        return meta;
    }

    @Override
    public boolean registerBus(EventBus bus, LoadController controller) {
        bus.register(this);
        return true;
    }

    @Subscribe
    public void preInit(FMLPreInitializationEvent event) {
        if (CommonUtils.isClient())
            ClientHandler.preInit();
    }

    @Subscribe
    public void init(FMLInitializationEvent event) {
        if (CommonUtils.isClient())
            ClientHandler.load();

        ServerHandler.load();
    }

    @Override
    public VersionRange acceptableMinecraftVersionRange() {
        return VersionParser.parseRange(CodeChickenCorePlugin.mcVersion);
    }

    @Override
    public File getSource() {
        return NEICorePlugin.location;
    }

    @Override
    public Class<?> getCustomResourcePackClass() {
        return getSource().isDirectory() ? FMLFolderResourcePack.class : FMLFileResourcePack.class;
    }
}

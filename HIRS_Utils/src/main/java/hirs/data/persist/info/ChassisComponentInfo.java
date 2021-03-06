package hirs.data.persist.info;

import hirs.data.persist.enums.ComponentType;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

/**
 * Class to hold chassis component information.
 */
@Entity
@DiscriminatorValue(value = ComponentType.Values.CHASSIS)
public class ChassisComponentInfo extends ComponentInfo {
    /**
     * Default constructor required by Hibernate.
     */
    public ChassisComponentInfo() {
    }

    /**
     * Constructor.
     *
     * @param componentManufacturer Component Manufacturer (must not be null)
     * @param componentModel        Component Model (must not be null)
     * @param componentSerial       Component Serial Number (can be null)
     * @param componentRevision     Component Revision or Version (can be null)
     */
    public ChassisComponentInfo(final String componentManufacturer,
                                final String componentModel,
                                final String componentSerial,
                                final String componentRevision) {
        super(componentManufacturer, componentModel,
                componentSerial, componentRevision);
    }
}

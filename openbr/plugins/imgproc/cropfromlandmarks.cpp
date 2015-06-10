#include <openbr/plugins/openbr_internal.h>

using namespace cv;

namespace br
{

/*!
 * \ingroup transforms
 * \brief Crops around the landmarks numbers provided.
 * \author Brendan Klare \cite bklare
 * \param padding Percentage of height and width to pad the image.
 */
class CropFromLandmarksTransform : public UntrainableTransform
{
    Q_OBJECT

    Q_PROPERTY(QList<int> indices READ get_indices WRITE set_indices RESET reset_indices STORED false)
    Q_PROPERTY(float padding READ get_padding WRITE set_padding RESET reset_padding STORED false)
    BR_PROPERTY(QList<int>, indices, QList<int>())
    BR_PROPERTY(float, padding, .1)

    void project(const Template &src, Template &dst) const
    {
        int minX = src.m().cols - 1,
            maxX = 1,
            minY = src.m().rows - 1,
            maxY = 1;

        for (int i = 0; i <indices.size(); i++) {
            if (minX > src.file.points()[indices[i]].x())
                minX = src.file.points()[indices[i]].x();
            if (minY > src.file.points()[indices[i]].y())
                minY = src.file.points()[indices[i]].y();
            if (maxX < src.file.points()[indices[i]].x())
                maxX = src.file.points()[indices[i]].x();
            if (maxY < src.file.points()[indices[i]].y())
                maxY = src.file.points()[indices[i]].y();
        }
        int padW = qRound((maxX - minX) * (padding / 2));
        int padH = qRound((maxY - minY) * (padding / 2));

        dst = Mat(src, Rect(minX - padW, minY - padH, (maxX - minX + 1) + padW * 2, (maxY - minY + 1) + padH * 2));
    }
};

BR_REGISTER(Transform, CropFromLandmarksTransform)

} // namespace br

#include "imgproc/cropfromlandmarks.moc"
